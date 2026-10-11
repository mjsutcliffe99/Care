from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'CARE' / 'Care'
DOCS = ROOT / 'website' / 'docs' / 'api'
NAV = ROOT / 'website' / 'docs' / 'api' / 'SUMMARY.md'
PATTERN = re.compile(r'^---\s*@([\w]+)(?:\s+(.*))?$')
LINK = re.compile(r'\b(care(?:\.[A-Za-z_]\w*)+)\b')

def parse(path):
    entries, block = [], []
    for line in path.read_text(encoding='utf-8').splitlines() + ['']:
        if line.startswith('---'):
            block.append(line)
        elif block:
            entry = {'params': [], 'returns': [], 'fields': [], 'example': []}
            example = False
            active_field = None
            for comment in block:
                m = PATTERN.match(comment)
                if m:
                    active_field = None
                    tag, val = m.group(1), (m.group(2) or '').strip()
                    if tag in ('function', 'method', 'class', 'module'):
                        entry['kind'] = tag
                        if tag == 'class' and ':' in val:
                            child, parent = val.split(':', 1)
                            entry['name'] = child.strip()
                            entry['parent'] = parent.strip()
                        else:
                            entry['name'] = val
                    elif tag == 'summary':
                        entry['summary'] = val
                    elif tag == 'description':
                        entry['description'] = val
                        active_field = 'description'
                    elif tag == 'param':
                        p = val.split(' ', 2)
                        if len(p) == 3: entry['params'].append(p)
                    elif tag == 'return':
                        p = val.split(' ', 2)
                        if len(p) == 3:
                            entry['returns'].append(tuple(p))
                        elif len(p) == 2:
                            entry['returns'].append(('', p[0], p[1]))
                        elif p:
                            entry['returns'].append(('', p[0], ''))
                    elif tag == 'field':
                        p = val.split(' ', 2)
                        if len(p) == 3: entry['fields'].append(p)
                    elif tag == 'example':
                        example = True
                elif example:
                    entry['example'].append(
                        comment[4:] if comment.startswith('--- ') else ''
                    )
                elif active_field == 'description':
                    text = comment[3:]
                    if text.startswith(' '):
                        text = text[1:]

                    entry['description'] += '\n' + text
            if 'kind' in entry:
                entry['signature'] = line.strip() if line.lstrip().startswith('function ') else None
                entries.append(entry)
            block = []
    return entries

def url_path(entry):
    parts = entry['name'].replace(':', '.').split('.')

    if len(parts) == 1:
        return Path('index.md')

    # Lowercase directory names, preserving function filenames.
    directories = [part.lower() for part in parts[1:-1]]

    if entry['kind'] in ('module', 'class'):
        return Path(*directories, parts[-1].lower(), 'index.md')

    return Path(*directories, parts[-1] + '.md')

def class_ancestors(entry, known):
    """Return immediate parent first, stopping at missing parents or cycles."""
    ancestors, seen = [], {entry['name']}
    parent = entry.get('parent')
    while parent and parent not in seen:
        seen.add(parent)
        ancestor = known.get(parent)
        if ancestor is None or ancestor['kind'] != 'class':
            break
        ancestors.append(ancestor)
        parent = ancestor.get('parent')
    return ancestors


def own_members(owner, known, kind):
    separator = ':' if kind == 'method' else '.'
    return [e for e in known.values()
            if e['kind'] == kind
            and separator in e['name']
            and e['name'].rsplit(separator, 1)[0] == owner['name']]


def effective_members(entry, known, kind):
    """Subclass definitions shadow inherited members of the same kind/name."""
    result = {}
    for owner in [entry] + class_ancestors(entry, known):
        for member in own_members(owner, known, kind):
            short = member['name'].rsplit(':' if kind == 'method' else '.', 1)[-1]
            result.setdefault(short, member)
    return sorted(result.values(), key=lambda e: e['name'].rsplit(':', 1)[-1].rsplit('.', 1)[-1].lower())


def overview_tables(entry, known):
    """Build linked member tables, including inherited class members."""
    name = entry['name']
    sections = []
    if entry['kind'] == 'module':
        groups = [
            ('Submodules', 'module', [e for e in known.values()
             if e['kind'] == 'module' and e['name'] != name
             and e['name'].rsplit('.', 1)[0] == name]),
            ('Functions', 'function', [e for e in known.values()
             if e['kind'] == 'function' and e['name'].rsplit('.', 1)[0] == name]),
            ('Classes', 'class', [e for e in known.values()
             if e['kind'] == 'class' and e['name'].rsplit('.', 1)[0] == name]),
        ]
    elif entry['kind'] == 'class':
        groups = [
            ('Functions', 'function', effective_members(entry, known, 'function')),
            ('Methods', 'method', effective_members(entry, known, 'method')),
        ]
    else:
        return sections
    for heading, kind, members in groups:
        members = sorted(members, key=lambda e: e['name'].lower())
        if not members:
            continue
        label = {'Submodules': 'Submodule', 'Functions': 'Function',
                 'Classes': 'Class', 'Methods': 'Method'}.get(heading, heading)
        sections += [f'## {heading}', '', f'| {label} | Description |', '| --- | --- |']
        for member in members:
            if entry['kind'] == 'class':
                display = member['name'].rsplit('.', 2)[-2] + '.' + member['name'].rsplit('.', 1)[-1] if kind == 'function' else member['name'].rsplit('.', 1)[-1]
            else:
                display = member['name'].split(':')[-1].split('.')[-1]
            desc = member.get('summary', '').replace('|', r'\|').replace('\n', ' ')
            sections.append(f'| [`{display}`]({relative_link(entry, member)}) | {desc} |')
        sections.append('')
    return sections


def inheritance_sections(entry, known):
    if entry['kind'] != 'class':
        return []
    lines = []
    ancestors = class_ancestors(entry, known)
    if ancestors:
        lines += ['## Superclasses', '']
        lines += [f'- [`{ancestor["name"]}`]({relative_link(entry, ancestor)})'
                  for ancestor in ancestors]
        lines.append('')
    elif entry.get('parent'):
        lines += ['## Superclasses', '', f'- `{entry["parent"]}` (not documented)', '']
    children = sorted((e for e in known.values() if e['kind'] == 'class'
                       and e.get('parent') == entry['name']), key=lambda e: e['name'].lower())
    if children:
        lines += ['## Subclasses', '']
        lines += [f'- [`{child["name"]}`]({relative_link(entry, child)})' for child in children]
        lines.append('')
    return lines

def syntax(entry):
    """Build a public-facing call signature from documented names and parameters."""
    public = entry['name']
    if entry['kind'] == 'method':
        public = 'source:' + public.rsplit(':', 1)[-1]
    args = ', '.join(param[0] for param in entry['params'])
    call = f'{public}({args})'
    returns = [name for name, typ, _ in entry['returns'] if typ != 'nil']
    if returns:
        names = [name or f'result{i + 1}' for i, name in enumerate(returns)]
        return f'{", ".join(names)} = {call}'
    return call


def link_api_references(text, entry, known):
    def replace(match):
        name = match.group(1)

        if name not in known:
            return match.group(0)

        target = known[name]
        url = relative_link(entry, target)

        return f'[{name}]({url})'

    return re.sub(
        r'\[(care(?:\.[A-Za-z_]\w*)+)\](?!\()',
        replace,
        text
    )


def relative_page_link(src, target):
    """Relative public URL for raw HTML links (MkDocs directory URLs).

    Unlike Markdown links, href attributes in HTML are not rewritten by
    MkDocs. A page generated from foo.md is served at foo/, while a page
    generated from foo/index.md is served at foo/.
    """
    import posixpath

    def page_directory(entry):
        path = url_path(entry).as_posix()
        if path == 'index.md':
            return '.'
        if path.endswith('/index.md'):
            return path[:-len('/index.md')]
        if path.endswith('.md'):
            return path[:-3].rstrip('/')
        return path

    source_dir = page_directory(src)
    target_dir = page_directory(target)
    relative = posixpath.relpath(target_dir, source_dir)
    return './' if relative == '.' else relative + '/'


def linked_title(entry, known):
    """Build a breadcrumb-like H1 with links to documented API ancestors."""
    name = entry['name']
    # A colon separates an instance method from its declaring class.
    owner, sep, method = name.partition(':')
    parts = owner.split('.')
    result = []
    for i, part in enumerate(parts):
        qualified = '.'.join(parts[:i + 1])
        target = known.get(qualified)
        if target is not None:
            label = (f'<a href="{relative_page_link(entry, target)}" '
                     f'style="font-family: inherit !important; font-size: inherit; '
                     f'font-weight: inherit; text-transform: inherit;">{part}</a>')
        else:
            label = part
        result.append(label)
    title = '.'.join(result)
    if sep:
        target = known.get(name)
        if target is not None:
            method = (f'<a href="{relative_page_link(entry, target)}" '
                      f'style="font-family: inherit !important; font-size: inherit; '
                      f'font-weight: inherit; text-transform: inherit;">{method}</a>')
        title += ':' + method
    return title


def render(entry, known):
    name = entry['name']
    def linked(value):
        return LINK.sub(lambda m: f'[{m.group(0)}]({{}})' if False else (f'[`{m.group(0)}`]({relative_link(entry,known[m.group(0)])})' if m.group(0) in known and m.group(0)!=name else f'`{m.group(0)}`'), value)
    kind = entry['kind'].capitalize()
    lines = [f'# {linked_title(entry, known)}', '', f'<span class="api-kind">{kind}</span>', '', entry.get('summary', ''), '']
    if entry.get('description'):
        lines += [entry['description'], '']
    lines += inheritance_sections(entry, known)
    lines += overview_tables(entry, known)
    if entry['kind'] in ('function','method'):
        lines += ['## Syntax', '', '```lua', syntax(entry), '```', '']
        lines += ['## Arguments', '']
        if entry['params']:
            lines += ['| Name | Type | Description |', '| --- | --- | --- |']
            lines += [f'| `{p}` | {linked(t)} | {d} |' for p,t,d in entry['params']]
        else: lines += ['None.']
        lines += ['', '## Returns', '']
        returns = [(n, t, d) for n, t, d in entry['returns'] if t != 'nil']
        if returns:
            lines += ['| Name | Type | Description |', '| --- | --- | --- |']
            lines += [f'| `{n or "result"}` | {linked(t)} | {d} |' for n, t, d in returns]
        else:
            lines += ['Nothing.']
    fields = []
    if entry['kind'] == 'class':
        seen_fields = set()
        for owner in [entry] + class_ancestors(entry, known):
            for p, t, d in owner['fields']:
                if p not in seen_fields:
                    seen_fields.add(p)
                    fields.append((owner, p, t, d))
    else:
        fields = [(entry, p, t, d) for p, t, d in entry['fields']]
    if fields:
        lines += ['', '## Fields', '', '| Name | Type | Description |', '| --- | --- | --- |']
        for owner, p, t, d in fields:
            display = f'{owner["name"].rsplit(".", 1)[-1]}.{p}' if entry['kind'] == 'class' else p
            field_label = f'`{display}`'
            if owner is not entry:
                field_label = f'[{field_label}]({relative_link(entry, owner)}#fields)'
            lines.append(f'| {field_label} | {linked(t)} | {d} |')
    if entry['example']:
        lines += ['', '## Example', '', '```lua', *entry['example'], '```']
    markdown = '\n'.join(lines).rstrip() + '\n'
    return link_api_references(markdown, entry, known)

def relative_link(src, target):
    import os
    from pathlib import PurePosixPath
    src_dir = url_path(src).parent
    target_path = url_path(target)
    return os.path.relpath(str(target_path), str(src_dir)).replace('\\','/')

def main():
    entries = [e for path in sorted(SOURCE.rglob('*.lua')) for e in parse(path)]
    entries.sort(key=lambda e: e['name'].lower())
    known = {e['name']: e for e in entries}
    for e in entries:
        path = DOCS / url_path(e)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(render(e, known), encoding='utf-8')
    # Build hierarchical navigation from module names.
    modules = [
        e for e in entries
        if e['kind'] == 'module' and e['name'] != 'care'
    ]

    tree = {}

    for module in modules:
        parts = module['name'].split('.')[1:]  # Remove 'care'
        node = tree

        for part in parts:
            node = node.setdefault(part, {})

        node['_entry'] = module


    def add_nav(node, depth=0):
        lines = []

        for name, child in sorted(node.items()):
            if name == '_entry':
                continue

            entry = child.get('_entry')
            indent = '    ' * depth

            if entry:
                url = url_path(entry).as_posix()
                lines.append(f'{indent}- [{name}]({url})')
            else:
                lines.append(f'{indent}- {name}')

            # Add documented functions and classes for this module.
            if entry:
                functions = [
                    e for e in entries
                    if e['kind'] == 'function'
                    and e['name'].rsplit('.', 1)[0] == entry['name']
                ]

                classes = [
                    e for e in entries
                    if e['kind'] == 'class'
                    and e['name'].rsplit('.', 1)[0] == entry['name']
                ]

                if functions:
                    lines.append(f'{"    " * (depth + 1)}- [Functions]({url})')
                    for e in functions:
                        lines.append(
                            f'{"    " * (depth + 2)}'
                            f'- [{e["name"].split(".")[-1]}]'
                            f'({url_path(e).as_posix()})'
                        )

                if classes:
                    lines.append(f'{"    " * (depth + 1)}- [Classes]({url})')
                    for c in classes:
                        lines.append(
                            f'{"    " * (depth + 2)}'
                            f'- [{c["name"].split(".")[-1]}]'
                            f'({url_path(c).as_posix()})'
                        )

                        # Show class-level functions (including constructors)
                        # alongside instance methods in the navigation.
                        class_functions = [
                            e for e in entries
                            if e['kind'] == 'function'
                            and e['name'].rsplit('.', 1)[0] == c['name']
                        ]
                        methods = [
                            e for e in entries
                            if e['kind'] == 'method'
                            and e['name'].rsplit(':', 1)[0] == c['name']
                        ]

                        for e in sorted(class_functions, key=lambda e: e['name'].lower()):
                            lines.append(
                                f'{"    " * (depth + 3)}'
                                f'- [{e["name"].rsplit(".", 1)[-1]}]'
                                f'({url_path(e).as_posix()})'
                            )

                        for e in sorted(methods, key=lambda e: e['name'].lower()):
                            lines.append(
                                f'{"    " * (depth + 3)}'
                                f'- [{e["name"].rsplit(":", 1)[-1]}]'
                                f'({url_path(e).as_posix()})'
                            )

            lines.extend(add_nav(child, depth + 1))

        return lines


    nav = [
        '# API Reference',
        '',
        '- [Overview](index.md)',
    ]
    nav.extend(add_nav(tree))
    NAV.write_text('\n'.join(nav)+'\n',encoding='utf-8')
    print(f'Generated {len(entries)} pages and {NAV}')

if __name__ == '__main__': main()

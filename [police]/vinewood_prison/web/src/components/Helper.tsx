import { Fragment, ReactNode } from 'react';

// Renders "**bold**" and "[Key]" in helper lines
function format(line: string) {
  const parts: ReactNode[] = [];
  const re = /\*\*(.+?)\*\*|\[(.+?)\]/g;
  let last = 0;
  let m: RegExpExecArray | null;
  let i = 0;
  while ((m = re.exec(line))) {
    if (m.index > last) parts.push(<Fragment key={i++}>{line.slice(last, m.index)}</Fragment>);
    if (m[1]) parts.push(<strong key={i++}>{m[1]}</strong>);
    else parts.push(<kbd key={i++}>{m[2]}</kbd>);
    last = m.index + m[0].length;
  }
  if (last < line.length) parts.push(<Fragment key={i++}>{line.slice(last)}</Fragment>);
  return parts;
}

export default function Helper({ lines }: { lines: string[] }) {
  const [title, ...rest] = lines;
  return (
    <aside className="helper" aria-live="polite">
      <div className="helper__title">{format(title ?? '')}</div>
      {rest.map((l, i) => <div key={i} className={i === 0 ? 'helper__status' : 'helper__line'}>{format(l)}</div>)}
    </aside>
  );
}

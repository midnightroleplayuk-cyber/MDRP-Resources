import React, { useMemo, useRef, useState } from 'react';
import { ItemEntry } from '../../store/stashAdmin';
import { getItemUrl } from '../../helpers';

interface Props {
  items: ItemEntry[];
  value: string;
  placeholder?: string;
  onChange: (name: string) => void;
}

// Item icon from ox_inventory's images, hidden if the image is missing.
const ItemImage: React.FC<{ name: string }> = ({ name }) => {
  const [failed, setFailed] = useState(false);
  if (!name || failed) return <span className="sa-itemsel-img sa-itemsel-img-empty" />;
  return (
    <img
      className="sa-itemsel-img"
      src={getItemUrl(name) || ''}
      alt=""
      loading="lazy"
      onError={() => setFailed(true)}
    />
  );
};

// Searchable item picker with item images.
const ItemSelect: React.FC<Props> = ({ items, value, placeholder, onChange }) => {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const ref = useRef<HTMLDivElement>(null);

  const selected = items.find((i) => i.name === value);
  const display = selected ? selected.label : value;

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    const list = q
      ? items.filter((i) => i.label.toLowerCase().includes(q) || i.name.toLowerCase().includes(q))
      : items;
    return list.slice(0, 60);
  }, [items, query]);

  React.useEffect(() => {
    if (!open) return;
    const onDoc = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onDoc);
    return () => document.removeEventListener('mousedown', onDoc);
  }, [open]);

  return (
    <div className="sa-itemsel" ref={ref}>
      <button className={`sa-itemsel-btn${open ? ' sa-itemsel-open' : ''}`} onClick={() => setOpen((o) => !o)}>
        {value ? <ItemImage name={value} /> : null}
        <span className={display ? 'sa-itemsel-btn-label' : 'sa-itemsel-ph'}>
          {display || placeholder || 'Select item'}
        </span>
        <span className="sa-select-arrow">▾</span>
      </button>
      {open && (
        <div className="sa-itemsel-pop">
          <input
            className="sa-itemsel-search"
            autoFocus
            value={query}
            placeholder="Search…"
            onChange={(e) => setQuery(e.target.value)}
          />
          <div className="sa-itemsel-list">
            {filtered.length === 0 && <div className="sa-itemsel-empty">No items</div>}
            {filtered.map((i) => (
              <button
                key={i.name}
                className={`sa-itemsel-opt${i.name === value ? ' sa-itemsel-opt-active' : ''}`}
                onClick={() => {
                  onChange(i.name);
                  setOpen(false);
                  setQuery('');
                }}
              >
                <ItemImage name={i.name} />
                <span className="sa-itemsel-texts">
                  <span className="sa-itemsel-label">{i.label}</span>
                  <span className="sa-itemsel-name">{i.name}</span>
                </span>
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default ItemSelect;

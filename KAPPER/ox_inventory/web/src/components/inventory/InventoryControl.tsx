import React, { useState, useRef, useEffect } from 'react';
import { useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import { DragSource } from '../../typings';
import { onUse } from '../../dnd/onUse';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import UsefulControls from './UsefulControls';
import GiveMenu from './GiveMenu';
import { MinusIcon, PlusIcon, UseIcon, UsersGiveIcon } from '../utils/icons/InventoryIcons';

const formatAmount = (n: number) => (n > 0 ? n.toLocaleString('en-US') : '0');
const digitsOnly = (s: string) => s.replace(/\D/g, '');
const countDigitsBefore = (s: string, index: number) => digitsOnly(s.substring(0, index)).length;

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [infoVisible, setInfoVisible] = useState(false);
  const [giveOpen, setGiveOpen] = useState(false);
  const [value, setValue] = useState(formatAmount(itemAmount));
  const inputRef = useRef<HTMLInputElement>(null);
  const cursorRef = useRef<number | null>(null);
  // Slot the player dragged onto Give — this is the item that will be given.
  const giveSlotRef = useRef<number | null>(null);

  const [, use] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => {
      source.inventory === 'player' && onUse(source.item);
    },
  }));

  // Drag a player item onto Give to pick WHICH item to give, then open the
  // nearby-players submenu.
  const [{ isOver }, give] = useDrop<DragSource, void, { isOver: boolean }>(() => ({
    accept: 'SLOT',
    drop: (source) => {
      if (source.inventory !== 'player') return;
      giveSlotRef.current = source.item.slot;
      setGiveOpen(true);
    },
    collect: (monitor) => ({ isOver: monitor.isOver() }),
  }));

  const commitValue = (raw: string, cursorIndex: number) => {
    const digitsBefore = countDigitsBefore(raw, cursorIndex);
    const num = parseInt(digitsOnly(raw), 10) || 0;

    setValue(formatAmount(num));
    dispatch(setItemAmount(num));
    cursorRef.current = digitsBefore;
  };

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) =>
    commitValue(event.target.value, event.target.selectionStart ?? 0);

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    const el = event.currentTarget;
    const pos = el.selectionStart ?? 0;

    if (pos !== el.selectionEnd) return;

    if (event.key === 'Backspace' && el.value[pos - 1] === ',') {
      event.preventDefault();
      commitValue(el.value.slice(0, pos - 2) + el.value.slice(pos), pos - 2);
    } else if (event.key === 'Delete' && el.value[pos] === ',') {
      event.preventDefault();
      commitValue(el.value.slice(0, pos) + el.value.slice(pos + 2), pos);
    }
  };

  const stepAmount = (delta: number) => {
    const next = Math.max(0, (parseInt(digitsOnly(value), 10) || 0) + delta);
    setValue(formatAmount(next));
    dispatch(setItemAmount(next));
  };

  const handleGive = (serverId: number) => {
    const slot = giveSlotRef.current;
    if (slot === null) return;
    fetchNui('giveItemToPlayer', { serverId, slot, count: itemAmount });
  };

  // Clear the remembered slot whenever the submenu closes, so a later click that
  // reopens it can never give a stale item.
  const handleSetGiveOpen = (open: boolean) => {
    if (!open) giveSlotRef.current = null;
    setGiveOpen(open);
  };

  useEffect(() => {
    if (!inputRef.current || cursorRef.current === null) return;
    let newPos = 0;
    let count = 0;

    for (let i = 0; i < value.length && count < cursorRef.current; i++) {
      if (/\d/.test(value[i])) count++;
      newPos++;
    }

    inputRef.current.setSelectionRange(newPos, newPos);
    cursorRef.current = null;
  }, [value]);

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />

      <div className="action-group">
        <div className="inventory-grid-title">
          <div className="inventory-grid-badge">
            <svg viewBox="0 0 24 24" width={20} height={20} fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
              <path d="M13 2 3 14h7l-1 8 10-12h-7l1-8z" />
            </svg>
          </div>
          <div className="inventory-grid-title-text">
            <p className="inventory-grid-label">{Locale.ui_actions || 'Ações'}</p>
            <span className="inventory-grid-subtitle">{Locale.ui_actions_sub || 'Usar, dar, dividir ou descartar'}</span>
          </div>
        </div>
        <div className="action-bar">
        <div className="action-bar-amount">
          <button className="action-bar-step" onClick={() => stepAmount(-1)} tabIndex={-1}>
            <MinusIcon size={15} />
          </button>
          <input
            className="action-bar-input"
            type="text"
            ref={inputRef}
            value={value}
            onChange={handleChange}
            onKeyDown={handleKeyDown}
            min={0}
          />
          <button className="action-bar-step" onClick={() => stepAmount(1)} tabIndex={-1}>
            <PlusIcon size={15} />
          </button>
        </div>

        <button
          className="action-bar-button action-bar-button-use"
          ref={(el) => {
            use(el);
          }}
          title="Arrasta um item aqui (ou tecla U) para usar"
        >
          <UseIcon size={28} />
          <span className="action-btn-label">{Locale.ui_use || 'Usar'}</span>
        </button>

        <button
          className={`action-bar-button action-bar-button-give${isOver ? ' action-bar-button-over' : ''}`}
          ref={(el) => {
            give(el);
          }}
          onClick={() => handleSetGiveOpen(!giveOpen)}
          title="Arrasta um item aqui (ou tecla G) para dar"
        >
          <UsersGiveIcon size={28} />
          <span className="action-btn-label">{Locale.ui_give || 'Dar'}</span>
        </button>

        <button className="action-bar-button" title="Shift + arrastar para dividir uma pilha">
          <svg viewBox="0 0 24 24" width={28} height={28} fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
            <path d="M6 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6z M6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6z M20 4L8.12 15.88 M14.47 14.48L20 20 M8.12 8.12L12 12" />
          </svg>
          <span className="action-btn-label">{Locale.ui_split || 'Dividir'}</span>
        </button>

        <button className="action-bar-button action-bar-button-discard" title="Arrasta um item para fora da janela para descartar">
          <svg viewBox="0 0 24 24" width={28} height={28} fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round">
            <path d="M3 6h18 M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2 M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6 M10 11v6 M14 11v6" />
          </svg>
          <span className="action-btn-label">{Locale.ui_discard || 'Descartar'}</span>
        </button>
        </div>
      </div>

      <GiveMenu open={giveOpen} setOpen={handleSetGiveOpen} onSelect={handleGive} />
    </>
  );
};

export default InventoryControl;

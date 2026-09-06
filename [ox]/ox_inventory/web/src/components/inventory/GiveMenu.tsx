import React, { useEffect, useState } from 'react';
import {
  FloatingFocusManager,
  FloatingOverlay,
  FloatingPortal,
  useDismiss,
  useFloating,
  useInteractions,
  useTransitionStyles,
} from '@floating-ui/react';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import { UsersGiveIcon } from '../utils/icons/InventoryIcons';

export interface NearbyPlayer {
  id: number;
  label: string;
}

interface Props {
  open: boolean;
  setOpen: (open: boolean) => void;
  onSelect: (serverId: number) => void;
}

const GiveMenu: React.FC<Props> = ({ open, setOpen, onSelect }) => {
  const [players, setPlayers] = useState<NearbyPlayer[]>([]);
  const [loading, setLoading] = useState(false);

  const { refs, context } = useFloating({ open, onOpenChange: setOpen });
  const dismiss = useDismiss(context, { outsidePressEvent: 'mousedown' });
  const { getFloatingProps } = useInteractions([dismiss]);
  const { isMounted, styles } = useTransitionStyles(context, {
    duration: 200,
    initial: { opacity: 0, transform: 'translate(-50%, -46%) scale(0.92)' },
    open: { opacity: 1, transform: 'translate(-50%, -50%) scale(1)' },
  });

  useEffect(() => {
    if (!open) return;

    let active = true;
    setLoading(true);
    fetchNui<NearbyPlayer[]>('getNearbyPlayers', {}).then((data) => {
      if (!active) return;
      setPlayers(Array.isArray(data) ? data : []);
      setLoading(false);
    });

    return () => {
      active = false;
    };
  }, [open]);

  if (!isMounted) return null;

  return (
    <FloatingPortal>
      <FloatingOverlay lockScroll className="give-overlay" style={{ opacity: styles.opacity }}>
        <FloatingFocusManager context={context}>
          <div ref={refs.setFloating} className="give-menu" style={styles} {...getFloatingProps()}>
            <div className="give-menu-head">
              <div className="give-menu-head-icon">
                <UsersGiveIcon size={20} />
              </div>
              <div className="give-menu-head-text">
                <p>{Locale.ui_give || 'Give'}</p>
                <span>{Locale.ui_nearby_players || 'Nearby players'}</span>
              </div>
              <button className="give-menu-x" onClick={() => setOpen(false)}>
                <svg xmlns="http://www.w3.org/2000/svg" height="0.8em" viewBox="0 0 400 528">
                  <path d="M376.6 84.5c11.3-13.6 9.5-33.8-4.1-45.1s-33.8-9.5-45.1 4.1L192 206 56.6 43.5C45.3 29.9 25.1 28.1 11.5 39.4S-3.9 70.9 7.4 84.5L150.3 256 7.4 427.5c-11.3 13.6-9.5 33.8 4.1 45.1s33.8 9.5 45.1-4.1L192 306 327.4 468.5c11.3 13.6 31.5 15.4 45.1 4.1s15.4-31.5 4.1-45.1L233.7 256 376.6 84.5z" />
                </svg>
              </button>
            </div>

            {loading ? (
              <div className="give-menu-empty">…</div>
            ) : players.length === 0 ? (
              <div className="give-menu-empty">{Locale.ui_no_players || 'No players nearby'}</div>
            ) : (
              <div className="give-menu-list">
                {players.map((player) => (
                  <button
                    key={player.id}
                    type="button"
                    className="give-menu-item"
                    onClick={() => {
                      onSelect(player.id);
                      setOpen(false);
                    }}
                  >
                    <span className="give-menu-item-name">{player.label}</span>
                    <span className="give-menu-item-id">#{player.id}</span>
                  </button>
                ))}
              </div>
            )}
          </div>
        </FloatingFocusManager>
      </FloatingOverlay>
    </FloatingPortal>
  );
};

export default GiveMenu;

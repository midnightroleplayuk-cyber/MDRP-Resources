import { useEffect, useState } from 'react';
import { closeUi, emit, inGame } from './lib/nui';
import type { UiConfig } from './types';
import Tablet from './surfaces/Tablet';
import Reception from './surfaces/Reception';
import Editor from './surfaces/Editor';
import Kiosk from './surfaces/Kiosk';
import CctvOverlay from './surfaces/CctvOverlay';
import Helper from './components/Helper';

type Open = { surface: string; data: any; ui: UiConfig };

export default function App() {
  const [open, setOpen] = useState<Open | null>(null);
  const [hidden, setHidden] = useState(false);
  const [helper, setHelper] = useState<string[] | null>(null);

  useEffect(() => {
    const onMessage = (e: MessageEvent) => {
      const msg = e.data;
      if (!msg || typeof msg !== 'object') return;
      if (msg.action === 'open') { setOpen({ surface: msg.surface, data: msg.data, ui: msg.ui }); setHidden(false); }
      if (msg.action === 'close') setOpen(null);
      if (msg.action === 'hide') setHidden(true);
      if (msg.action === 'show') setHidden(false);
      if (msg.action === 'push') emit(msg.event, msg.data);
      if (msg.action === 'helper') setHelper(Array.isArray(msg.lines) && msg.lines.length ? msg.lines : null);
      if (msg.action === 'sound') {
        const audio = new Audio(msg.file ? `./sounds/${msg.file}` : `./sounds/${msg.name}.wav`);
        audio.volume = typeof msg.volume === 'number' ? Math.max(0, Math.min(1, msg.volume)) : 0.45;
        audio.play().catch(() => undefined);
      }
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') { setOpen(null); closeUi(); }
    };
    window.addEventListener('message', onMessage);
    window.addEventListener('keydown', onKey);
    return () => { window.removeEventListener('message', onMessage); window.removeEventListener('keydown', onKey); };
  }, []);

  const helperEl = helper ? <Helper lines={helper} /> : null;
  if (!open) return helperEl;
  if (open.surface === 'cctv') return <>{helperEl}{!hidden && <CctvOverlay data={open.data} />}</>;
  const close = () => { setOpen(null); closeUi(); };
  const ui = open.ui ?? { prisonDisplayName: 'Prison', serviceName: 'Prison Service' };

  return (
    <>
    {helperEl}
    <div className={`backdrop${inGame ? '' : ' backdrop--browser'}`} style={hidden ? { display: 'none' } : undefined}>
      {open.surface === 'tablet' && <Tablet initial={open.data} ui={ui} onClose={close} />}
      {open.surface === 'reception' && <Reception initial={open.data} ui={ui} onClose={close} />}
      {open.surface === 'editor' && <Editor initial={open.data} ui={ui} onClose={close} />}
      {open.surface === 'kiosk' && <Kiosk initial={open.data} ui={ui} onClose={close} />}
    </div>
    </>
  );
}

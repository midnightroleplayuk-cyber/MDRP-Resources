import { ReactNode, useEffect, useState } from 'react';

// The rugged tablet body. Everything is laid out on the artwork's own 1536 x 1024 grid
// and scaled to fit the window, so the screen and buttons always line up with the image.
const W = 1536;
const H = 1024;
const SCREEN = { left: 172, top: 147, width: 1198, height: 704 };
const SIDE = { left: 46, width: 68 };
const KEYS = [
  { id: 'power', top: 250, height: 68 },
  { id: 'p1', top: 335, height: 69 },
  { id: 'p2', top: 421, height: 68 },
  { id: 'p3', top: 507, height: 68 },
] as const;
const HOME = { left: 650, top: 905, width: 236, height: 46 };

export type DeviceKey = 'power' | 'p1' | 'p2' | 'p3' | 'home';

function useScale() {
  const calc = () => Math.min((window.innerWidth * 0.96) / W, (window.innerHeight * 0.96) / H);
  const [scale, setScale] = useState(calc);
  useEffect(() => {
    const on = () => setScale(calc());
    window.addEventListener('resize', on);
    return () => window.removeEventListener('resize', on);
  }, []);
  return scale;
}

export default function TabletDevice({ children, onKey, labels, poweringOff }: {
  children: ReactNode;
  onKey: (key: DeviceKey) => void;
  labels: Partial<Record<DeviceKey, string>>;
  poweringOff: boolean;
}) {
  const scale = useScale();
  return (
    <div className="device-stage" style={{ width: W * scale, height: H * scale }}>
      <div className="device" style={{ width: W, height: H, transform: `scale(${scale})` }}>
        <img className="device__body" src="./tablet/frame.webp" alt="" draggable={false} />
        <div className={`device__screen${poweringOff ? ' is-off' : ''}`} style={SCREEN}>
          {children}
          <div className="device__glass" aria-hidden="true" />
        </div>
        {KEYS.map((k) => (
          <button key={k.id} className="device__key" aria-label={labels[k.id] ?? k.id} title={labels[k.id]}
            style={{ left: SIDE.left, width: SIDE.width, top: k.top, height: k.height }} onClick={() => onKey(k.id)} />
        ))}
        <button className="device__key device__key--home" aria-label={labels.home ?? 'Home'} title={labels.home}
          style={HOME} onClick={() => onKey('home')} />
      </div>
    </div>
  );
}

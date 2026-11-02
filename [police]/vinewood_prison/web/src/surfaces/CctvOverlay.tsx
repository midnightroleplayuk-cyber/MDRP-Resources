import { useEffect, useState } from 'react';

export default function CctvOverlay({ data }: { data: { label: string; index: number; count: number; zoom?: number } }) {
  const [time, setTime] = useState(new Date());
  useEffect(() => { const t = setInterval(() => setTime(new Date()), 1000); return () => clearInterval(t); }, []);
  return (
    <div className="cctv">
      <div className="cctv__top">
        <span className="cctv__rec">REC</span>
        <span>CAM {String(data.index).padStart(2, '0')} / {String(data.count).padStart(2, '0')}</span>
        <span className="cctv__label">{data.label}</span>
        <span>ZOOM {(data.zoom ?? 1).toFixed(1)}×</span>
        <span className="cctv__time">{time.toLocaleDateString('en-GB')} {time.toLocaleTimeString('en-GB')}</span>
      </div>
      <div className="cctv__hint">WASD pan and tilt · Mouse fine adjust · Scroll zoom · R reset view · ← → change camera · Backspace back to the tablet</div>
    </div>
  );
}

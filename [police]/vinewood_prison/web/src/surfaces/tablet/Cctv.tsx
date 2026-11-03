import { useEffect, useState } from 'react';
import { call, local } from '../../lib/nui';
import { Button, Empty } from '../../components/ui';

type Camera = { id: number; label: string; cam: unknown };

export default function Cctv({ prisonId, onError }: { prisonId: number; onError: (e: string) => void }) {
  const [cams, setCams] = useState<Camera[] | null>(null);
  useEffect(() => {
    call<{ cameras: Camera[] }>('cctv:list', prisonId).then((res) => { if (res.ok) setCams(res.cameras); else onError(res.error); });
  }, [prisonId]);

  if (!cams) return <p className="muted">Loading cameras…</p>;
  return (
    <>
      <h1>CCTV</h1>
      {cams.length === 0 ? <Empty>No cameras. An administrator can add them in the editor.</Empty> : (
        <>
          <p className="lede">WASD pans and tilts, the mouse fine-adjusts, scroll zooms and R resets to the saved view. The arrow keys change camera, and Backspace brings you back here.</p>
          <table className="table">
            <tbody>
              {cams.map((c, i) => (
                <tr key={c.id}>
                  <td className="mono" style={{ width: 70 }}>CAM {String(i + 1).padStart(2, '0')}</td>
                  <td>{c.label}</td>
                  <td className="num"><Button small onClick={() => local('cctv', cams, i + 1)}>Watch</Button></td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </>
  );
}

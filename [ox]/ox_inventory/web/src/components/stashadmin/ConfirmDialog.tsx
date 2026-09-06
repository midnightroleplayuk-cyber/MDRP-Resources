import React from 'react';
import { TrashIcon } from './icons';

interface Props {
  open: boolean;
  title: string;
  message: string;
  confirmLabel?: string;
  onConfirm: () => void;
  onCancel: () => void;
}

// Small centered confirmation modal (themed) for destructive actions.
const ConfirmDialog: React.FC<Props> = ({ open, title, message, confirmLabel = 'Delete', onConfirm, onCancel }) => {
  if (!open) return null;
  return (
    <div className="sa-confirm-overlay" onMouseDown={onCancel}>
      <div className="sa-confirm" onMouseDown={(e) => e.stopPropagation()}>
        <div className="sa-confirm-icon">
          <TrashIcon size={22} />
        </div>
        <h3>{title}</h3>
        <p>{message}</p>
        <div className="sa-confirm-actions">
          <button className="sa-confirm-cancel" onClick={onCancel}>
            Cancel
          </button>
          <button className="sa-confirm-delete" onClick={onConfirm}>
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmDialog;

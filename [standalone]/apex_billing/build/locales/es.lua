--[[
    Apex Billing — Spanish (ES) locale
]]

Locales = Locales or {}
Locales.es = {
    -- Notificaciones
    n_issued_ok        = 'Factura #%s emitida — %s.',
    n_received_invoice = 'Has recibido una factura de %s — %s.',
    n_paid_ok          = 'Factura #%s pagada (%s).',
    n_paid_in          = '%s pagó la factura #%s — %s.',
    n_declined_ok      = 'Factura #%s rechazada.',
    n_declined_in      = '%s rechazó la factura #%s.',
    n_amount_invalid   = 'Cantidad inválida.',
    n_no_funds         = 'No tienes suficiente dinero para pagar esta factura.',
    n_no_society_funds = 'La tesorería de la empresa no puede cubrir esta factura.',
    n_no_printer       = 'Necesitas una Impresora de Facturas para emitir facturas.',
    n_no_recipient     = 'No se ha seleccionado ningún destinatario.',
    n_no_perm          = 'No tienes permiso para emitir facturas en este trabajo.',
    n_inv_not_found    = 'Factura no encontrada.',
    n_inv_already_paid = 'Esta factura ya ha sido pagada.',
    n_inv_expired      = 'Esta factura ha expirado.',
    n_too_many_pending = 'Tienes demasiadas facturas pendientes.',
    n_self_billed      = 'No puedes facturarte a ti mismo.',
    n_payout_received  = 'Facturas pagadas mientras no estabas: %s ingresados en tu banco.',

    -- HUD
    hud_open_billing   = 'Abrir facturación',

    -- UI
    wm_first           = 'APEX',
    wm_second          = 'BILLING',
    ui_brand           = 'Apex Billing',
    ui_dashboard       = 'Panel',
    ui_new_invoice     = 'Nueva Factura',
    ui_sent            = 'Enviadas',
    ui_received        = 'Recibidas',
    ui_society         = 'Empresa',
    ui_templates       = 'Plantillas',
    ui_settings        = 'Ajustes',

    ui_recipient       = 'Destinatario',
    ui_recipient_hint  = 'Elige un jugador cercano o pega un ID de ciudadano',
    ui_title           = 'Título',
    ui_due_date        = 'Vencimiento',
    ui_line_items      = 'Líneas',
    ui_add_item        = 'Añadir línea',
    ui_qty             = 'Cant',
    ui_unit_price      = 'Precio',
    ui_subtotal        = 'Subtotal',
    ui_vat             = 'IVA',
    ui_total           = 'Total',
    ui_send_invoice    = 'Enviar factura',
    ui_save_template   = 'Guardar como plantilla',
    ui_pay             = 'Pagar',
    ui_decline         = 'Rechazar',
    ui_cancel          = 'Cancelar',

    ui_status_draft    = 'Borrador',
    ui_status_sent     = 'Pendiente',
    ui_status_paid     = 'Pagada',
    ui_status_declined = 'Rechazada',
    ui_status_expired  = 'Expirada',
    ui_status_cancelled= 'Cancelada',

    ui_empty_sent      = 'Aún no has enviado facturas.',
    ui_empty_received  = 'No has recibido facturas.',
    ui_empty_society   = 'Aún no hay facturas de la empresa.',
    ui_empty_template  = 'Aún no hay plantillas.',
}

import { create } from 'zustand'

export interface Notification {
  id: string
  type: 'success' | 'error' | 'warning' | 'info'
  title: string
  message?: string
  duration?: number
  timestamp: number
}

interface NotificationsStore {
  notifications: Notification[]
  
  addNotification: (notification: Omit<Notification, 'id' | 'timestamp'>) => string
  removeNotification: (id: string) => void
  clearNotifications: () => void
  
  success: (title: string, message?: string, duration?: number) => string
  error: (title: string, message?: string, duration?: number) => string
  warning: (title: string, message?: string, duration?: number) => string
  info: (title: string, message?: string, duration?: number) => string
}

export const useNotificationsStore = create<NotificationsStore>((set, get) => ({
  notifications: [],

  addNotification: (notification) => {
    const id = `notification_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
    const newNotification: Notification = {
      ...notification,
      id,
      timestamp: Date.now(),
      duration: notification.duration ?? 5000 // 5 segundos por defecto
    }
    
    set((state) => ({
      notifications: [...state.notifications, newNotification]
    }))

    // Auto-dismiss si tiene duración
    if (newNotification.duration && newNotification.duration > 0) {
      setTimeout(() => {
        get().removeNotification(id)
      }, newNotification.duration)
    }
    
    return id
  },

  removeNotification: (id) => {
    set((state) => ({
      notifications: state.notifications.filter(notif => notif.id !== id)
    }))
  },

  clearNotifications: () => {
    set({ notifications: [] })
  },

  success: (title, message, duration) => {
    return get().addNotification({
      type: 'success',
      title,
      message,
      duration
    })
  },

  error: (title, message, duration) => {
    return get().addNotification({
      type: 'error',
      title,
      message,
      duration: duration ?? 5000
    })
  },

  warning: (title, message, duration) => {
    return get().addNotification({
      type: 'warning',
      title,
      message,
      duration
    })
  },

  info: (title, message, duration) => {
    return get().addNotification({
      type: 'info',
      title,
      message,
      duration
    })
  }
}))

export const useNotifications = () => {
  const store = useNotificationsStore()
  
  return {
    notifications: store.notifications,
    notify: {
      success: store.success,
      error: store.error,
      warning: store.warning,
      info: store.info
    },
    remove: store.removeNotification,
    clear: store.clearNotifications
  }
}

import { useState, useEffect, useCallback, useRef } from 'react';

const SOUND_KEY = 'sound_notifications_enabled';

// Função para tocar o som de notificação
const playNotificationSound = () => {
  try {
    // Cria uma nova instância de Audio para cada notificação
    // Isso evita problemas com múltiplas notificações simultâneas
    const audio = new Audio('/notification.mp3');
    audio.volume = 0.8;
    
    // Tenta tocar o som
    const playPromise = audio.play();
    
    if (playPromise !== undefined) {
      playPromise
        .then(() => {
          console.log('Notificação sonora tocada com sucesso');
        })
        .catch(error => {
          console.warn('Erro ao tocar notificação sonora (Autoplay bloqueado):', error);
        });
    }
  } catch (error) {
    console.error('Erro ao criar instância de áudio:', error);
  }
};

export function useSoundNotification() {
  const [isEnabled, setIsEnabled] = useState<boolean>(() => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem(SOUND_KEY);
      return stored ? JSON.parse(stored) : true; // Default to true
    }
    return true;
  });

  useEffect(() => {
    localStorage.setItem(SOUND_KEY, JSON.stringify(isEnabled));
  }, [isEnabled]);

  const toggleSound = useCallback((checked: boolean) => {
    setIsEnabled(checked);
    if (checked) {
      // Toca uma notificação de teste ao ativar
      playNotificationSound();
    }
  }, []);

  const notify = useCallback(() => {
    if (isEnabled) {
      playNotificationSound();
    }
  }, [isEnabled]);

  return { isEnabled, toggleSound, notify };
}
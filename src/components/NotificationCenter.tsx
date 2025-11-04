"use client";

import React, { useState } from 'react';
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogTrigger } from "@/components/ui/dialog";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Bell, X } from "lucide-react";
import { useToast } from "@/hooks/use-toast"; // Assuming useToast is for general app toasts

interface Notification {
  id: string;
  message: string;
  timestamp: string;
}

export default function NotificationCenter() {
  const { toast } = useToast();
  const [notifications, setNotifications] = useState<Notification[]>([
    { id: "1", message: "Novo pedido #PED-12345 chegou!", timestamp: "2024-08-01T10:00:00Z" },
    { id: "2", message: "Estoque do Frango Assado está baixo.", timestamp: "2024-08-01T09:30:00Z" },
    { id: "3", message: "Lembrete: Limpar a chapa hoje.", timestamp: "2024-07-31T18:00:00Z" },
  ]);
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const handleDismiss = (id: string) => {
    setNotifications(prev => prev.filter(notif => notif.id !== id));
    toast({ title: "Notificação dispensada." });
  };

  const handleClearAll = () => {
    setNotifications([]);
    toast({ title: "Todas as notificações limpas." });
    setIsDialogOpen(false);
  };

  return (
    <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="sm" className="relative">
          <Bell className="h-4 w-4" />
          {notifications.length > 0 && (
            <span className="absolute -top-1 -right-1 flex h-3 w-3">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-3 w-3 bg-red-500"></span>
            </span>
          )}
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Notificações ({notifications.length})</DialogTitle>
        </DialogHeader>
        <ScrollArea className="h-[300px] py-4">
          <div className="space-y-3 pr-4">
            {notifications.length === 0 ? (
              <p className="text-center text-muted-foreground py-8">Nenhuma notificação.</p>
            ) : (
              notifications.map(notif => (
                <div key={notif.id} className="flex items-center justify-between p-3 bg-accent rounded-lg">
                  <div>
                    <p className="text-sm font-medium">{notif.message}</p>
                    <p className="text-xs text-muted-foreground">
                      {new Date(notif.timestamp).toLocaleString('pt-BR')}
                    </p>
                  </div>
                  <Button variant="ghost" size="sm" onClick={() => handleDismiss(notif.id)}>
                    OK
                  </Button>
                </div>
              ))
            )}
          </div>
        </ScrollArea>
        <DialogFooter>
          <Button variant="outline" onClick={handleClearAll} disabled={notifications.length === 0}>
            Limpar Tudo
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
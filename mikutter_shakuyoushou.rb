#-*- coding: utf-8 -*-
 
Plugin.create :mikutter_shakuyoushou do
  command(:shakuyoushou,
    name: '借用証を発行する',
    condition: lambda{ |opt| true },
    visible: true,
    role: :timeline) do |opt|

    opt.messages.each { |m|
      # Create the dialog
      dialog = Gtk::Dialog.new("借用証を発行する",
                               $main_application_window,
                               Gtk::Dialog::DESTROY_WITH_PARENT,
                               [ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_OK ],
                               [ Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL ])

      dialog.vbox.add(Gtk::Label.new("借用している金額を入力してください"))
      kingaku_box = Gtk::Entry.new
      dialog.vbox.add(kingaku_box)
      dialog.show_all

      result = dialog.run
      kingaku = nil
      if result == Gtk::Dialog::RESPONSE_OK
        kingaku = kingaku_box.text
      end
      dialog.destroy

      if kingaku != nil
        Service.primary.post(:message =>"　　　　　借　用　証
 
@#{m.user.to_s} 様
　　　　　　　　#{Time.now.strftime('%Y年%m月%d日')}
 
　　金　#{kingaku}　円　也
　　￣￣￣￣￣￣￣￣￣￣￣
　　　　　　　　〒▒░-▓▒
　　　　　　　　░▓▒▓░▓▒-░-▒▒
　　　　　　　　@#{Service.primary.user.to_s}", :replyto => m)
      end
    }
  end
end

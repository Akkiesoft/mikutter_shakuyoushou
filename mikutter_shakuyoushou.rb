#-*- coding: utf-8 -*-
 
Plugin.create :mikutter_shakuyoushou do
  command(:shakuyoushou,
    name: '借用証を発行する',
    condition: lambda{ |opt| true },
    visible: true,
    role: :timeline) do |opt|

    opt.messages.each { |m|

      # 書類の種類
      list = ["借　用　証","領　収　書","請　求　書"]
    
      # Create the dialog
      dialog = Gtk::Dialog.new("借用証を発行する",
                               $main_application_window,
                               Gtk::Dialog::DESTROY_WITH_PARENT,
                               [ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_OK ],
                               [ Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL ])

      dialog.vbox.add(Gtk::Label.new("借用している金額を入力してください"))
      kingaku_box = Gtk::Entry.new
      dialog.vbox.add(kingaku_box)

      dialog.vbox.add(Gtk::Label.new("書類の種類を選択してください"))
      mogmog = Gtk::ComboBox.new(true)
      dialog.vbox.add(mogmog)
      list.each do |s|
      mogmog.append_text(s)
    end
    mogmog.set_active(0)

      dialog.show_all

      result = dialog.run
      kingaku = nil
      mogmogindex = nil
      if result == Gtk::Dialog::RESPONSE_OK
        kingaku = kingaku_box.text
        mogmogindex = mogmog.active
      end
      dialog.destroy

      if kingaku != nil
        world, = Plugin.filtering(:world_current, nil)
        user = world.user_obj.idname
        compose(world, m, body: ".　　　　　#{list[mogmogindex]}
 
@#{m.user.idname} 様
　　　　　　　　#{Time.now.strftime('%Y年%m月%d日')}
 
　　金　#{kingaku}　円　也
　　￣￣￣￣￣￣￣￣￣￣￣
　　　　　　　　〒▒░-▓▒
　　　　　　　　░▓▒▓░▓▒-░-▒▒
　　　　　　　　@#{user}")
      end
    }
  end
end

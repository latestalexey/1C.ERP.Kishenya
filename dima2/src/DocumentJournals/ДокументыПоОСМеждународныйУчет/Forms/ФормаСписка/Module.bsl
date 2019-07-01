
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАмортизацияОС(Команда)
	ОткрытьФорму("Документ.АмортизацияОСМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИзменениеПараметровОС(Команда)
	ОткрытьФорму("Документ.ИзменениеПараметровОСМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПереводОСИИ(Команда)
	ОткрытьФорму("Документ.ПереводОсновныхСредствИнвестиционногоИмуществаМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеремещениеОС(Команда)
	ОткрытьФорму("Документ.ПеремещениеОСМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПринятиеКУчетуОС(Команда)
	ОткрытьФорму("Документ.ПринятиеКУчетуОСМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРегистрацияНаработок(Команда)
	ОткрытьФорму("Документ.РегистрацияНаработок.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеОС(Команда)
	ОткрытьФорму("Документ.СписаниеОСМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти

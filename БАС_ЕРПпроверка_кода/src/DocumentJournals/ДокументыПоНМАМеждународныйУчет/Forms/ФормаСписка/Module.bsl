
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАмортизацияНМА(Команда)
	ОткрытьФорму("Документ.АмортизацияНМАМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыработкаНМА(Команда)
	ОткрытьФорму("Документ.ВыработкаНМА.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИзменениеПараметровНМА(Команда)
	ОткрытьФорму("Документ.ИзменениеПараметровНМАМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеремещениеНМА(Команда)
	ОткрытьФорму("Документ.ПеремещениеНМАМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПринятиеКУчетуНМА(Команда)
	ОткрытьФорму("Документ.ПринятиеКУчетуНМАМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеНМА(Команда)
	ОткрытьФорму("Документ.СписаниеНМАМеждународныйУчет.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("ВладелецТоварныхКатегорий") Тогда
			Если ЗначениеЗаполнено(Параметры.Отбор.ВладелецТоварныхКатегорий) Тогда
				Параметры.Отбор.Вставить("Владелец", Параметры.Отбор.ВладелецТоварныхКатегорий);
			КонецЕсли;
			
			Параметры.Отбор.Удалить("ВладелецТоварныхКатегорий");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
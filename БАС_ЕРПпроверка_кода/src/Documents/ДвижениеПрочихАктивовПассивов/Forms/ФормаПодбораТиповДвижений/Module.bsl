
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Не Элемент.ТекущиеДанные = Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТипДвижений = Новый Структура("Источник, Получатель, Увеличение, Описание");
		ЗаполнитьЗначенияСвойств(ТипДвижений, Элемент.ТекущиеДанные);
		
		ОповеститьОВыборе(ТипДвижений);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

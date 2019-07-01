
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивИсключаемыхЗначений = Новый Массив;
	МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы"));
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты"));
	КонецЕсли;
	
	ОбщегоНазначенияУТВызовСервера.ПолучитьСписокВыбораПеречисления(
		"ВариантыРаспределенияРасходов",
		ДанныеВыбора,
		Параметры,
		МассивИсключаемыхЗначений);
		
КонецПроцедуры

#КонецОбласти


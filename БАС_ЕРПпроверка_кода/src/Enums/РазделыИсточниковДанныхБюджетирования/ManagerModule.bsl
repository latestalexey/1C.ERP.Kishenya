
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	МассивИсключаемыхЗначений = Новый Массив;
	
	Если НЕ ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет"));
	КонецЕсли;

	ОбщегоНазначенияУТВызовСервера.ПолучитьСписокВыбораПеречисления(
		"РазделыИсточниковДанныхБюджетирования",
		ДанныеВыбора,
		Параметры,
		МассивИсключаемыхЗначений);
	
КонецПроцедуры

#КонецОбласти


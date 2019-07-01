#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		МассивИсключаемыхЗначений = Новый Массив;
		МассивИсключаемыхЗначений.Добавить(Перечисления.ТипыОбеспечения.Производство);
		
		ОбщегоНазначенияУТ.ПолучитьСписокВыбораПеречисления(
			"ТипыОбеспечения",
			ДанныеВыбора,
			Параметры,
			МассивИсключаемыхЗначений);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

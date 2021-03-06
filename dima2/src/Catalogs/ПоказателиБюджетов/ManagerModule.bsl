#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
// 
// Возвращаемое значание:
// 	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ВидАналитики1");
	Результат.Добавить("ВидАналитики2");
	Результат.Добавить("ВидАналитики3");
	Результат.Добавить("ВидАналитики4");
	Результат.Добавить("ВидАналитики5");
	Результат.Добавить("ВидАналитики6");
	Результат.Добавить("УчитыватьПоКоличеству");
	Результат.Добавить("УчитыватьПоВалюте");
	Результат.Добавить("ТипПоказателя");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	//++ НЕ УТ
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуОборотноСальдоваяВедомостьБюджетированияПоПоказателюБюджетов(КомандыОтчетов);
	//-- НЕ УТ

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли

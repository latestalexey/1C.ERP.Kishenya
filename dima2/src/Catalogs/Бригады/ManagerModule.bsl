#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значание:
//	Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	Результат = Новый Массив;
	Результат.Добавить("Организация");
	Результат.Добавить("Подразделение");
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли
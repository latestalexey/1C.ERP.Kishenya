#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает данные о версии мобильного приложения из макета в XML-виде
//
// Параметры:
//  ИмяМакета - Строка - имя макета
//
// Возвращаемое значение:
//  Строка, содержащая данные о версии мобильного приложения из макета в XML-виде
//
Функция ПолучитьXMLДанныеВерсииПриложения(ИмяМакета) Экспорт
	
	Макет = Справочники.ВерсииМобильныхПриложений.ПолучитьМакет(ИмяМакета);
	
	Возврат Макет.ПолучитьТекст();

КонецФункции

// Формирует и возращает список, содержащий имена макетов, из которых можно загрузить приложения
//
// Возвращаемое значение:
//  Список версий - Список значений - содержит имена макетов и их представления
//
Функция ПолучитьСписокВерсийДляЗагрузкиИзМакетов() Экспорт
	
	Список = Новый СписокЗначений();

	КоллекцияМакетов = Метаданные.Справочники.ВерсииМобильныхПриложений.Макеты;

	ТекстовыйМакет = Метаданные.СвойстваОбъектов.ТипМакета.ТекстовыйДокумент;
	
	Для Каждого Макет из КоллекцияМакетов Цикл
		Если Макет.ТипМакета = ТекстовыйМакет Тогда
        	ИмяМакета = Макет.Имя;
        	Список.Добавить(ИмяМакета, Макет.Синоним);
        КонецЕсли;
    КонецЦикла;

    Возврат Список;

#КонецОбласти
КонецФункции
#КонецЕсли
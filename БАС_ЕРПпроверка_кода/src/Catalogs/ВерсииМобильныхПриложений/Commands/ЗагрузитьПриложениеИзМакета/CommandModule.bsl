
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗагрузитьПриложенияИзМакетов();
	
КонецПроцедуры

&НаКлиенте
// Выполняет загрузку приложения из макетов, хранимых в конфигурации
//
Процедура ЗагрузитьПриложенияИзМакетов()
	
	СписокВерсий = ПолучитьСписокВерсий();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьПриложенияИзМакетовЗавершение", ЭтотОбъект);
	
	ВыбранныйЭлемент = Неопределено;
	
	ЗаголовокВыбора = НСтр("ru='Выбор приложения для загрузки';uk='Вибір програми для завантаження'");
	
	СписокВерсий.ПоказатьВыборЭлемента(ОписаниеОповещения, ЗаголовокВыбора, ВыбранныйЭлемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПриложенияИзМакетовЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора <> Неопределено Тогда
		ЗагрузитьДанныеИзМакета(РезультатВыбора.Значение);
		ОповеститьОбИзменении(Тип("СправочникСсылка.ВерсииМобильныхПриложений"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Формирует и возвращает список значений, содержащий данные о версиях
// мобильных приложений, которые могут быть загружены из макетов
//
// Возвращаемое значение:
//  Список значений, содержащий данные о версиях приложений для загрузки из макетов
// 
Функция ПолучитьСписокВерсий()
	
	Возврат Справочники.ВерсииМобильныхПриложений.ПолучитьСписокВерсийДляЗагрузкиИзМакетов();
	
КонецФункции

&НаСервере
// Выполняет загрузку приложения из указанного макета
//
// Параметры:
//  ИмяМакета - имя макета, содержащего данные версии мобильного приложения
//
Процедура ЗагрузитьДанныеИзМакета(ИмяМакета)

	МобильныеПриложения.ЗагрузитьВерсиюПриложенияИзМакета(ИмяМакета);
	
КонецПроцедуры
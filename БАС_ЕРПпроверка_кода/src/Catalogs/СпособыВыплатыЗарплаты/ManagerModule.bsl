#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область МетодыПолученияСпособовВыплаты

// Возвращает способ выплаты зарплаты по умолчанию
//
// Возвращаемое значение:
//  СправочникСсылка.СпособыВыплатыЗарплаты - способ выплаты зарплаты по умолчанию
//
Функция ПоУмолчанию() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СпособыВыплатыЗарплаты.Зарплата");
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиВызовСервера.СпособыВыплатыЗарплатыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура НачальноеЗаполнение() Экспорт
	ВзаиморасчетыССотрудникамиВнутренний.СпособыВыплатыЗарплатыНачальноеЗаполнение();
КонецПроцедуры

Процедура ОбновитьУдаленныеПредопределенные() Экспорт
	
	СпособВыплатыСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СпособыВыплатыЗарплаты.Зарплата");
	
	Если СпособВыплатыСсылка <> Неопределено И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СпособВыплатыСсылка, "ПометкаУдаления") Тогда
		
		СпособВыплаты = СпособВыплатыСсылка.ПолучитьОбъект();
		СпособВыплаты.ПометкаУдаления = Ложь;
		СпособВыплаты.Записать();
		
	КонецЕсли;
	
	ЗапросПоискаОбъекта = Новый Запрос;
	
	ЗапросПоискаОбъекта.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	                            |	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	                            |ИЗ
	                            |	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	                            |ГДЕ
	                            |	СпособыВыплатыЗарплаты.ПометкаУдаления
	                            |	И СпособыВыплатыЗарплаты.Наименование = &Наименование";
	
	ЗапросПоискаОбъекта.УстановитьПараметр("Наименование", "Аванс");
	
	Выборка = ЗапросПоискаОбъекта.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СпособВыплаты = Выборка.Ссылка.ПолучитьОбъект();
		СпособВыплаты.ПометкаУдаления = Ложь;
		СпособВыплаты.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПризнакПоставляемый() Экспорт
	ВзаиморасчетыССотрудникамиВнутренний.СпособыВыплатыЗарплатыЗаполнитьПризнакПоставляемый()	
КонецПроцедуры

Процедура ЗаполнитьОкругление() Экспорт
	
	СпособОкругленияПоУмолчанию = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.Округление = ЗНАЧЕНИЕ(Справочник.СпособыОкругленияПриРасчетеЗарплаты.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СпособВыплаты = Выборка.Ссылка.ПолучитьОбъект();
		СпособВыплаты.Округление = СпособОкругленияПоУмолчанию;
		СпособВыплаты.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьХарактерВыплаты() Экспорт
	
	СпособВыплатыЗарплата = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СпособыВыплатыЗарплаты.Зарплата");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыВыплатыЗарплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СпособыВыплатыЗарплаты КАК СпособыВыплатыЗарплаты
	|ГДЕ
	|	СпособыВыплатыЗарплаты.ХарактерВыплаты = ЗНАЧЕНИЕ(Перечисление.ХарактерВыплатыЗарплаты.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СпособВыплаты = Выборка.Ссылка.ПолучитьОбъект();
		
		Если Выборка.Ссылка = СпособВыплатыЗарплата Тогда
			СпособВыплаты.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Зарплата;
		Иначе
			СпособВыплаты.ХарактерВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс;
		КонецЕсли;	
		
		СпособВыплаты.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
	
#КонецОбласти

#КонецЕсли
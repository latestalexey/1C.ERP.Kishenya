
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.ИзменениеПараметровНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//++ НЕ УТКА
	Документы.ПеремещениеНМАМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//-- НЕ УТКА
		
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПеремещениеНМА) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ПеремещениеНМА.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ПеремещениеНМА);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
		
	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции


Процедура ИнициализироватьДанныеДокументаУКР(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru='Перемещение НМА';uk='Переміщення НМА'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализацииУКР(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПорядокОтраженияПрочихОпераций(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	//ГрафикиАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	МестонахождениеНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры);
	ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры);
	ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры);
	СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры);
		
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры


Процедура ЗаполнитьПараметрыИнициализацииУКР(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.СобытиеОС,
	|	ДанныеДокумента.ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.НематериальныйАктив, 
	|	ДанныеДокумента.МОЛ,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.МОЛПолучатель,
	|	ДанныеДокумента.ПодразделениеПолучатель,
	|	ДанныеДокумента.АдресМестонахожденияПолучателя,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.НачислениеАмортизации = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НачислятьАмортизацию,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.НачислениеАмортизации = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ИзменятьПризнакНачисленияАмортизации,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов,
	|	ВЫБОР ДанныеДокумента.ХозяйственнаяОперация
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперацииРеглУчет.ПеремещениеОСвПодразделениеВыделенноеНаБаланс)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоПередача,
	|	ВЫБОР ДанныеДокумента.ХозяйственнаяОперация
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперацииРеглУчет.ПеремещениеНМА)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоПеремещениеНМА,
	|	ДанныеДокумента.СтатьяРасходовНалог,
	|	ДанныеДокумента.АналитикаРасходовНалог,
	|	ДанныеДокумента.ИзменяетсяОтражениеРасходовПоНалогу
	|ИЗ
	|	Документ.ПеремещениеНМА КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	УчетОСВызовСервера.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос, ДополнительныеСвойства);
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("Граница", Новый Граница(НачалоМесяца(Реквизиты.Период), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("НазваниеДокумента", НСтр("ru='Перемещение НМА';uk='Переміщення НМА'"));
	
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Реквизиты.Организация, Реквизиты.Период));
	
КонецПроцедуры


Процедура ВременнаяТаблицаНМА_УКР(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаНМА";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица НМА
	|"+
	"ВЫБРАТЬ
	|	ТаблицаНМА.Ссылка,
	|	1 КАК НомерСтроки,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив
	|ПОМЕСТИТЬ ТаблицаНМА
	|ИЗ
	|	Документ.ПеремещениеНМА КАК ТаблицаНМА
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры


Процедура МестонахождениеНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "МестонахождениеНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаНМА_УКР(ТекстыЗапроса);
		
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица МестонахождениеНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&МОЛПолучатель КАК МОЛ,
	|	&ПодразделениеПолучатель КАК Местонахождение
	|	
	| "+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


Процедура ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаНМА_УКР(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК ПервоначальнаяСтоимость,
	|	&НачислятьАмортизацию КАК НачислятьАмортизацию,
	|	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.СпособНачисленияАмортизации КАК СпособНачисленияАмортизации,
	|	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
	|	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость
	|ИЗ
	|		РегистрСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.СрезПоследних(
	|				&Период,
	|				Организация = &Организация
	|				И Регистратор <>&Ссылка
	|				И НематериальныйАктив = &НематериальныйАктив) КАК ПервоначальныеСведенияНМАБухгалтерскийУчетСрезПоследних
	|ГДЕ
	|&ИзменятьПризнакНачисленияАмортизации
	|	"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


Процедура ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАНалоговыйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаНМА_УКР(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАНалоговыйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних.НалоговаяГруппаОС КАК НалоговаяГруппаОС,
	|	ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних.ПервоначальнаяСтоимостьНУ  КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних.СпособНачисленияАмортизацииНУ КАК СпособНачисленияАмортизацииНУ,
	|	ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних.СрокПолезногоИспользования КАК СрокПолезногоИспользования,
	|	&НачислятьАмортизацию КАК НачислятьАмортизацию,
	|	ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних.НалоговоеНазначение КАК НалоговоеНазначение
	|	
	|ИЗ
	|    РегистрСведений.ПервоначальныеСведенияНМАНалоговыйУчет.СрезПоследних(
	|																			&Период,
	|																			Организация = &Организация
	|																			И НематериальныйАктив =	&НематериальныйАктив
	|																			И Регистратор <>&Ссылка)
	|КАК ПервоначальныеСведенияНМАНалоговыйУчетСрезПоследних
	|ГДЕ
	|	&ИзменятьПризнакНачисленияАмортизации	
	|"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


Процедура СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|
	|	&Организация КАК Организация,
	|	&НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА &СтатьяРасходов
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.СтатьяРасходов
	|	КОНЕЦ КАК СтатьяРасходов,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА &АналитикаРасходов
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.АналитикаРасходов
	|	КОНЕЦ КАК АналитикаРасходов,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА ЛОЖЬ
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.СпособОтраженияРасходовЗаданДокументом
	|	КОНЕЦ КАК СпособОтраженияРасходовЗаданДокументом,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.СпособОтраженияРасходов
	|	КОНЕЦ КАК СпособОтраженияРасходов
	|ИЗ
	|		РегистрСведений.СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.СрезПоследних(
	|				&Период,
	|				Организация = &Организация
	|				И Регистратор <>&Ссылка
	|				И НематериальныйАктив =	&НематериальныйАктив) КАК СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет
	|ГДЕ
	|	&НачислятьАмортизацию
	|
	|	"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры



#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	Разделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Возврат УчетНМА.ТекстОтраженияВРеглУчетеНачисленнойАмортизацииУКР()
 	    + Разделитель + ПеремещениеНМА_УКР()
		+ Разделитель + ПеремещениеАмортизацииУКР()
	;
	
КонецФункции

Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат УчетНМА.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизацииУКР("ПеремещениеНМА")
		+ УчетНМА.ТекстЗапросаВТОтраженияВРеглУчетеОстаткиПоСчетамУКР();

КонецФункции

Функция ПеремещениеНМА_УКР()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Перемещение НМА (Дт СчетУчета:: Кт СчетУчета)
	|ВЫБРАТЬ
	|	
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьБУ, 0) КАК Сумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.ПодразделениеПолучатель КАК ПодразделениеДт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	втОстаткиПоСчетам.НалоговоеНазначениеСчетУчета		 КАК НалоговоеНазначениеДт,//НужноДобавитьНалоговоеНазначениеДт 
	|	
	|	СчетаОтражения.СчетУчета КАК СчетДт,
	|	Операция.НематериальныйАктив  КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьНУ, 0) КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	втОстаткиПоСчетам.НалоговоеНазначениеСчетУчета КАК НалоговоеНазначениеКт, 
	|	
	|	СчетаОтражения.СчетУчета КАК СчетКт,
	|	Операция.НематериальныйАктив  КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьНУ, 0) КАК СуммаНУКт,
	//|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьПР, 0) КАК СуммаПРКт,
	//|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьВР, 0) КАК СуммаВРКт,
    |	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Перемещение НМА"" КАК Содержание
	|ИЗ
	|	Документ.ПеремещениеНМА КАК Операция
	|	
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Операция.НематериальныйАктив = СчетаОтражения.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Операция.НематериальныйАктив = втОстаткиПоСчетам.ОбъектУчета
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
КонецФункции

Функция ПеремещениеАмортизацииУКР()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Перемещение амортизации НМА (Дт СчетНачисленияАмортизации:: Кт СчетНачисленияАмортизации)
	|ВЫБРАТЬ
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияБУ, 0) КАК Сумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	ТЧНачисленнаяАмортизация.НалоговоеНазначение КАК НалоговоеНазначениеДт,
	|
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетДт,
	|	Операция.НематериальныйАктив  КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияПР, 0) КАК СуммаПРДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияВР, 0) КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.ПодразделениеПолучатель КАК ПодразделениеКт,
	|	Операция.НематериальныйАктив.НаправлениеДеятельности КАК НаправлениеДеятельностКДт,
	|	ТЧНачисленнаяАмортизация.НалоговоеНазначение КАК НалоговоеНазначениеКт,//НужноДобавитьНалоговоеНазначениеКт 
	|	
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетКт,
	|	Операция.НематериальныйАктив  КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Перемещение амортизации НМА"" КАК Содержание
	|ИЗ
	|	Документ.ПеремещениеНМА КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеНМА.НачисленнаяАмортизация КАК ТЧНачисленнаяАмортизация
	|		ПО ТЧНачисленнаяАмортизация.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Операция.НематериальныйАктив = СчетаОтражения.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Операция.НематериальныйАктив = втОстаткиПоСчетам.ОбъектУчета
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
		
КонецПроцедуры


#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	УчетОСВызовСервера.ЗаполнитьВходящиеДанныеАмортизации(ВходящиеДанные);
	
	ЗакрытиеМесяцаУТВызовСервера.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
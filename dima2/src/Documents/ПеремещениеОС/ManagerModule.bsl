
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.ИзменениеПараметровОС.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//++ НЕ УТКА
	Документы.ПеремещениеОСМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//-- НЕ УТКА
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПеремещениеОС) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ПеремещениеОС.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ПеремещениеОС);
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

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru='Перемещение ОС';uk='Переміщення ОЗ'"));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПорядокОтраженияПрочихОпераций(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПереоценкаОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	ГрафикиАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	МестонахождениеОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	НачислениеАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	НачислениеАмортизацииОСНалоговыйУчет(ТекстыЗапроса, Регистры);
	СобытияОСОрганизаций(ТекстыЗапроса, Регистры);
	СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.СобытиеОС,
	|	ДанныеДокумента.ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.МОЛ,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.ОрганизацияПолучатель,
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
	|	КОНЕЦ КАК ЭтоПередача
	|ИЗ
	|	Документ.ПеремещениеОС КАК ДанныеДокумента
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
	Запрос.УстановитьПараметр("НазваниеДокумента", НСтр("ru='Перемещение ОС';uk='Переміщення ОЗ'"));
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Реквизиты.Организация, Реквизиты.Период));
	
КонецПроцедуры

Процедура ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаОС";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица ТаблицаОС
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка,
	|	ТаблицаОС.НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ПеремещениеОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ГрафикиАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ГрафикиАмортизацииОСБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ГрафикиАмортизацииОСБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&ОрганизацияПолучатель КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ГрафикиАмортизацииОСБухгалтерскийУчет.ГрафикАмортизации КАК ГрафикАмортизации
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикиАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|				&Период,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						Т.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК Т)) КАК ГрафикиАмортизацииОСБухгалтерскийУчет
	|		ПО ТаблицаОС.ОсновноеСредство = ГрафикиАмортизацииОСБухгалтерскийУчет.ОсновноеСредство
	|ГДЕ
	|	&ЭтоПередача
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура МестонахождениеОСБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "МестонахождениеОСБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица МестонахождениеОСБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	ВЫБОР КОГДА &ЭтоПередача
	|		ТОГДА &ОрганизацияПолучатель
	|		ИНАЧЕ &Организация
	|	КОНЕЦ КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&МОЛПолучатель КАК МОЛ,
	|	&ПодразделениеПолучатель КАК Местонахождение,
	|	&АдресМестонахожденияПолучателя КАК АдресМестонахождения
	|	
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура НачислениеАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НачислениеАмортизацииОСБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица НачислениеАмортизацииОСБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&НачислятьАмортизацию  КАК НачислятьАмортизацию
	|	
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|ГДЕ
	|	&ИзменятьПризнакНачисленияАмортизации 
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура НачислениеАмортизацииОСНалоговыйУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НачислениеАмортизацииОСНалоговыйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица НачислениеАмортизацииОСНалоговыйУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&НачислятьАмортизацию КАК НачислятьАмортизацию
	|	
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|	
	|ГДЕ
	|	&ИзменятьПризнакНачисленияАмортизации 
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры



Процедура СобытияОСОрганизаций(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СобытияОСОрганизаций";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СобытияОСОрганизаций
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	&СобытиеОС КАК Событие,
	|	
	|	&НазваниеДокумента КАК НазваниеДокумента,
	|	&Номер КАК НомерДокумента,
	|	0 КАК СуммаЗатратБУ,
	|	0 КАК СуммаЗатратНУ
	|	
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВременнаяТаблицаОсновныхСредств(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки,
	|	
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА &СтатьяРасходов
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СтатьяРасходов
	|	КОНЕЦ КАК СтатьяРасходов,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА &АналитикаРасходов
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.АналитикаРасходов
	|	КОНЕЦ КАК АналитикаРасходов,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА ЛОЖЬ
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СпособОтраженияРасходовЗаданДокументом
	|	КОНЕЦ КАК СпособОтраженияРасходовЗаданДокументом,
	|	ВЫБОР КОГДА &НачислятьАмортизацию
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СпособОтраженияРасходов
	|	КОНЕЦ КАК СпособОтраженияРасходов
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|				&Период,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						Т.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК Т)) КАК СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет
	|		ПО ТаблицаОС.ОсновноеСредство = СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.ОсновноеСредство
	|ГДЕ
	|	&НачислятьАмортизацию
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


#КонецОбласти

#Область ПроведениеПоРеглУчету


Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	Разделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Возврат УчетОСВызовСервера.ТекстОтраженияВРеглУчетеНачисленнойАмортизации()
		+ Разделитель + ПеремещениеОС()
		+ Разделитель + ПеремещениеАмортизации();
		
КонецФункции

Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизацииУКР("ПеремещениеОС")
		+ УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеОстаткиПоСчетам();
	
КонецФункции

Функция ПеремещениеОС()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Перемещение ОС (Дт СчетУчета:: Кт СчетУчета)
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
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|   НалоговыеНазначенияОС.НалоговоеНазначение КАК НалоговоеНазначениеДт,
	|	
	|	СчетаОтражения.СчетУчета КАК СчетДт,
	|	Строки.ОсновноеСредство КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьНУ, 0) КАК СуммаНУДт,
	|   0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|   НалоговыеНазначенияОС.НалоговоеНазначение КАК НалоговоеНазначениеКт,
	|	
	|	СчетаОтражения.СчетУчета КАК СчетКт,
	|	Строки.ОсновноеСредство КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.ВосстановительнаяСтоимостьНУ, 0) КАК СуммаНУКт,
	|   0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Перемещение ОС"" КАК Содержание
	|ИЗ
	|	Документ.ПеремещениеОС КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеОС.ОС КАК Строки
	|		ПО Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Строки.ОсновноеСредство = СчетаОтражения.ОбъектУчета	
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТНалоговыеНазначенияОС КАК НалоговыеНазначенияОС
	|		ПО Строки.ОсновноеСредство = НалоговыеНазначенияОС.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Строки.ОсновноеСредство = втОстаткиПоСчетам.ОбъектУчета
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперацииРеглУчет.ПеремещениеОС)
	|";
	
КонецФункции

Функция ПеремещениеАмортизации()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////////////////////////
	|// Перемещение амортизации ОС (Дт СчетНачисленияАмортизации:: Кт СчетНачисленияАмортизации)
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
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|   НалоговыеНазначенияОС.НалоговоеНазначение КАК НалоговоеНазначениеДт,
	|	
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетДт,
	|	Строки.ОсновноеСредство КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	Операция.ПодразделениеПолучатель КАК ПодразделениеКт,
	|	Строки.ОсновноеСредство.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|   НалоговыеНазначенияОС.НалоговоеНазначение КАК НалоговоеНазначениеКт,
	|	
	|	СчетаОтражения.СчетНачисленияАмортизации КАК СчетКт,
	|	Строки.ОсновноеСредство КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ЕСТЬNULL(втОстаткиПоСчетам.НакопленнаяАмортизацияНУ, 0) КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Перемещение амортизации ОС"" КАК Содержание
	|ИЗ
	|	Документ.ПеремещениеОС КАК Операция
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеОС.ОС КАК Строки
	|		ПО Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втСчетаОтражения КАК СчетаОтражения
	|		ПО Строки.ОсновноеСредство = СчетаОтражения.ОбъектУчета
	|	
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТНалоговыеНазначенияОС КАК НалоговыеНазначенияОС
	|		ПО Строки.ОсновноеСредство = НалоговыеНазначенияОС.ОбъектУчета
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиПоСчетам КАК втОстаткиПоСчетам
	|		ПО Строки.ОсновноеСредство = втОстаткиПоСчетам.ОбъектУчета
	|	
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперацииРеглУчет.ПеремещениеОС)
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

		
	// Форма ОЗ-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОЗ1";
	КомандаПечати.Представление = НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОЗ1") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОЗ1",
			НСтр("ru='Форма ОЗ-1';uk='Форма ОЗ-1'"), ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета),, ИмяМакета);
	КонецЕсли;	
	
КонецПроцедуры

// Функция формирует табличный документ с печатной формой ОЗ-1,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОЗ1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	УстановитьПривилегированныйРежим(Истина);

	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеремещениеОС_ОЗ1";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_UK_ОЗ1");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл	
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка",         Ссылка);
		Запрос.УстановитьПараметр("ТекДата",        Ссылка.МоментВремени());
		Запрос.УстановитьПараметр("ТекОрганизация", Ссылка.Организация);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПеремещениеОС.Дата                                   КАК ДатаАкта,
		|	ПеремещениеОС.Номер                                  КАК НомерАкта, 
		|	ПеремещениеОС.ПодразделениеПолучатель.Представление КАК ПринялоПодразделение,
		|	ПеремещениеОС.ПодразделениеПолучатель               КАК ПодразделениеПриняло,
		|	ВЫРАЗИТЬ(ПеремещениеОС.Организация.НаименованиеПолное 
		|	                    КАК СТРОКА(1000))     КАК Организация,
		|	ПеремещениеОС.Организация.КодПоЕДРПОУ               КАК ЕДРПОУ
		|ИЗ
		|	Документ.ПеремещениеОС КАК ПеремещениеОС
		|ГДЕ
		|	ПеремещениеОС.Ссылка = &Ссылка";
		ВыборкаПоШапке = Запрос.Выполнить().Выбрать();
		ВыборкаПоШапке.Следующий();

		СписокОС = Ссылка.ОС.ВыгрузитьКолонку("ОсновноеСредство");
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка"        , Ссылка);
		Запрос.УстановитьПараметр("СписокОС"      , СписокОС);
		Запрос.УстановитьПараметр("ТекДата"       , Новый Граница(Ссылка.МоментВремени(), ВидГраницы.Исключая));
		Запрос.УстановитьПараметр("ТекОрганизация", Ссылка.Организация);
		Запрос.УстановитьПараметр("СостояниеВвода", Перечисления.СостоянияОС.ПринятоКУчету);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПервоначальныеСведенияБУ.ИнвентарныйНомер           КАК ИнвентарныйНомер,
		|	ПервоначальныеСведенияБУ.ПервоначальнаяСтоимость    КАК ПервоначальнаяСтоимость,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета                КАК СчетКт,
		|	СчетаБухгалтерскогоУчетаОС.СчетУчета                КАК СчетДт,
		|	ПеремещениеОСОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
		|	ПеремещениеОСОС.ОсновноеСредство.ЗаводскойНомер     КАК ЗаводскойНомер,
		|	ПеремещениеОСОС.ОсновноеСредство.ДатаВыпуска        КАК ГодВыпуска,
		|	ПеремещениеОСОС.ОсновноеСредство.НомерПаспорта      КАК НомерПаспорта,
		|	МестонахождениеОС.МОЛ.Код                           КАК КодМОЛа,
		|	МестонахождениеОС.Местонахождение.Представление     КАК СдалоПодразделение,
		|	МестонахождениеОС.Местонахождение                   КАК Подразделение,
		|	СостоянияОС.ДатаСостояния                           КАК ДатаВвода
		|ИЗ
		|	Документ.ПеремещениеОС.ОС КАК ПеремещениеОСОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|		                    &ТекДата,
		|		                    ОсновноеСредство В (&СписокОС)
		|		                    И Организация = &ТекОрганизация) КАК ПервоначальныеСведенияБУ
		|		ПО ПеремещениеОСОС.ОсновноеСредство = ПервоначальныеСведенияБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|		                    &ТекДата,
		|		                    ОсновноеСредство В (&СписокОС)
		|		                    И Организация = &ТекОрганизация) КАК СчетаБухгалтерскогоУчетаОС
		|		ПО ПеремещениеОСОС.ОсновноеСредство = СчетаБухгалтерскогоУчетаОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|			                &ТекДата,
		|		                    Организация = &ТекОрганизация
		|			                И ОсновноеСредство В (&СписокОС)) КАК МестонахождениеОС
		|		ПО ПеремещениеОСОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ 
		|			(ВЫБРАТЬ
		|				СостоянияОС.ОсновноеСредство КАК ОсновноеСредство,
		|				СостоянияОС.ДатаСостояния    КАК ДатаСостояния
		|			ИЗ
		|				РегистрСведений.СостоянияОСОрганизаций КАК СостоянияОС
		|			ГДЕ
		|				СостоянияОС.Организация = &ТекОрганизация
		|				И СостоянияОС.Состояние = &СостояниеВвода
		|				И СостоянияОС.ОсновноеСредство В(&СписокОС)) КАК СостоянияОС
		|		ПО ПеремещениеОСОС.ОсновноеСредство = СостоянияОС.ОсновноеСредство
		|ГДЕ
		|	ПеремещениеОСОС.Ссылка = &Ссылка";
			
		Результат = Запрос.Выполнить();
		ВыборкаПоОС = Результат.Выбрать();
		
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Ссылка);
		
		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Ссылка.Организация, Ссылка.Дата);
		
		Пока ВыборкаПоОС.Следующий() Цикл

			ОбластьМакета = Макет.ПолучитьОбласть("ОЗ1");
			Параметры     = ОбластьМакета.Параметры;
			Параметры.Заполнить(ВыборкаПоШапке);
			Параметры.Заполнить(ВыборкаПоОС);
			Параметры.Заполнить(ВыборкаПоКомиссии);
			Параметры.Организация = СокрП(ВыборкаПоШапке.Организация);
			Параметры.Валюта      = ВалютаРегламентированногоУчета;
			Параметры.ВидОперации = "Внутр. перемі-" + Символы.ПС + "щення";
			
			ОсновныеСотрудникиФизическихЛицПринял = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Ссылка.Принял, Истина, Ссылка.Организация, Ссылка.Дата);
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицПринял) Тогда
				Для каждого Строка Из ОсновныеСотрудникиФизическихЛицПринял Цикл
				    ДанныеФизЛицаПолучил = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);			
				КонецЦикла;
				Для каждого СтрокаДанныеПолучил Из ДанныеФизЛицаПолучил Цикл			
					ОбластьМакета.Параметры.ПолучилДолжность = СтрокаДанныеПолучил.Должность;
					ОбластьМакета.Параметры.ПолучилФИО 			= СтрокаДанныеПолучил.ФизическоеЛицо;			
				КонецЦикла;
			КонецЕсли;
			ОсновныеСотрудникиФизическихЛицСдал = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Ссылка.Сдал, Истина, Ссылка.Организация, Ссылка.Дата);
			Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицСдал) Тогда		
				Для каждого Строка Из ОсновныеСотрудникиФизическихЛицСдал Цикл
					ДанныеФизЛицаСдал = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);
				КонецЦикла;
				Для каждого СтрокаДанныеСдал Из ДанныеФизЛицаСдал Цикл
					ОбластьМакета.Параметры.СдалДолжность 	= СтрокаДанныеСдал.Должность;
					ОбластьМакета.Параметры.СдалФИО	 		= СтрокаДанныеСдал.ФизическоеЛицо;
				КонецЦикла;			
			КонецЕсли;
						
			ОбластьМакета.Параметры.ГлавныйБухгалтер 	= ОтветственныеЛица.ГлавныйБухгалтерПредставление;
			
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;	
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьОЗ1()


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
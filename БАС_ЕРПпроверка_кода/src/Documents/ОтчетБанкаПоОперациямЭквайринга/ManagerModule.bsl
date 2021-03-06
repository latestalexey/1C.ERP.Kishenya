#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт


	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);


КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьОплатуПлатежнымиКартами";
	

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


//++ НЕ УТ
#Область ПроведениеПоРеглУчетуУКР

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//                                                                               
Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	ТекстКомиссия = "
	|ВЫБРАТЬ // Поступление услуг (Дт 9X :: Кт 3332)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Операция.СуммаКомиссии КАК Сумма,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|	НЕОПРЕДЕЛЕНО КАК НалоговоеНазначениеДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Операция.СтатьяРасходов КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	Операция.СуммаКомиссии КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	Операция.Валюта КАК ВалютаКт,
	|	Операция.БанковскийСчет.Подразделение КАК ПодразделениеКт,
	|	Операция.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	НЕОПРЕДЕЛЕНО КАК НалоговоеНазначениеКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам) КАК СчетКт,
	|	Операция.Эквайер КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	Операция.СуммаКомиссии КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Комиссия за услуги эквайринга"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетБанкаПоОперациямЭквайринга КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|ГДЕ
	|	Операция.СуммаКомиссии <> 0
	|";
	
	Возврат ТекстКомиссия;
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламетированном учете
//
Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат "";
	
КонецФункции

#КонецОбласти  

//-- НЕ УТ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);

	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	ТекстыЗапроса.Добавить(ТекстЗапросаТаблицаКнигаДоходовРасходовПоЕдиномуНалогу(),     "ТаблицаКнигаДоходовРасходовПоЕдиномуНалогу");
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.СтатьяДекларацииПоЕдиномуНалогу КАК СтатьяДекларацииПоЕдиномуНалогу,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Валюта", Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов")); 
	Запрос.УстановитьПараметр("СтатьяДекларацииПоЕдиномуНалогу", Реквизиты.СтатьяДекларацииПоЕдиномуНалогу);
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", Справочники.Организации.НалоговоеНазначениеНДС(Реквизиты.Организация, Реквизиты.Период));
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") 
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Запрос.Параметры.Валюта,
																			,
																			Запрос.Параметры.Период);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Коэффициенты.КоэффициентПересчетаВВалютуУПР);
		
КонецПроцедуры

Функция ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЭквайрингу";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.СписаниеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                                               КАК ВидДвижения,
	|	ДанныеДокумента.Дата                                                                 КАК Период,
	|	
	|	ДанныеДокумента.Организация                                                          КАК Организация,
	|	ДанныеДокумента.БанковскийСчет                                                       КАК Получатель,
	|	НЕОПРЕДЕЛЕНО                                                                         КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)   КАК ВидПереводаДенежныхСредств,
	|	ДанныеДокумента.Эквайер                                                              КАК Контрагент,
	|	ДанныеДокумента.Валюта                                                               КАК Валюта,
	|	
	|	ДанныеДокумента.СуммаКомиссии                                                                КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК Число(15, 2))   КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл  КАК Число(15, 2)) КАК СуммаРегл,
	|	
	|	НЕОПРЕДЕЛЕНО                                                                         КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочиеРасходы) КАК ХозяйственнаяОперация,
	|	
    //++ НЕ УТ
    |   &НалоговоеНазначениеОрганизации КАК НалоговоеНазначение, 
    |	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15,2)) КАК СуммаРегл,
    |	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15,2)) КАК СуммаРеглБезНДС,
    //-- НЕ УТ
	|	// Рассчитаем сумму в валюте управленческого учета.
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15,2)) КАК Сумма
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|	И &ИспользоватьУчетПрочихДоходовРасходов";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	Значение(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	ДанныеПлатежногоДокумента.Организация КАК Организация,
	|	ДанныеПлатежногоДокумента.Подразделение КАК Подразделение,
	|
	|	НЕОПРЕДЕЛЕНО КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера) КАК ТипДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеПлатежногоДокумента.Ссылка.Валюта КАК Валюта,
	|
	|	ДанныеПлатежногоДокумента.СтатьяРасходов КАК СтатьяДоходовРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаДоходов,
	|	ДанныеПлатежногоДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|
	|	ВЫРАЗИТЬ(ДанныеПлатежногоДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеПлатежногоДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ДанныеПлатежногоДокумента.СуммаКомиссии КАК СуммаВВалюте,
	|
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУДенежныхСредств,
	|	ДанныеПлатежногоДокумента.СтатьяРасходов КАК ИсточникГФУДоходовРасходов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеПлатежногоДокумента
	|
	|ГДЕ
	|	ДанныеПлатежногоДокумента.Ссылка = &Ссылка
	|	И ДанныеПлатежногоДокумента.СуммаКомиссии <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаКнигаДоходовРасходовПоЕдиномуНалогу()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	&СтатьяДекларацииПоЕдиномуНалогу КАК Статья,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаПоПартнерам,
	|	НЕОПРЕДЕЛЕНО КАК ЗаказКлиента,
	|	НЕОПРЕДЕЛЕНО КАК РасчетныйДокумент,
	|	&Валюта КАК Валюта,
	|	&Период КАК ДатаПлатежа,
	|	ВЫБОР КОГДА &СтатьяДекларацииПоЕдиномуНалогу <> ЗНАЧЕНИЕ(Справочник.СтатьиНалоговыхДеклараций.ЕННК_ДоходыВозвраты) ТОГДА
	|		ОтчетБанкаПоОперациямЭквайринга.СуммаПоЕдиномуНалогу
	|	ИНАЧЕ
	|		- ОтчетБанкаПоОперациямЭквайринга.СуммаПоЕдиномуНалогу
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ОтчетБанкаПоОперациямЭквайринга
	|ГДЕ
	|	ОтчетБанкаПоОперациямЭквайринга.Ссылка = &Ссылка
	|	И &СтатьяДекларацииПоЕдиномуНалогу <> ЗНАЧЕНИЕ(Справочник.СтатьиНалоговыхДеклараций.ПустаяСсылка)
	|	И &СтатьяДекларацииПоЕдиномуНалогу <> ЗНАЧЕНИЕ(Справочник.СтатьиНалоговыхДеклараций.ЕННК_ДоходыДоходомНеПризнается)
	|	И ОтчетБанкаПоОперациямЭквайринга.СуммаПоЕдиномуНалогу <> 0
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ПеренестиРеквизитыПотерянныеСоответствия_ДанныеДляОбновления(Параметры) Экспорт
	
	Запрос = Новый Запрос;
    
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
    |ГДЕ 
    |   ДанныеДокумента.УДАЛИТЬСтатьяДекларацииПоЕдиномуНалогу <> ДанныеДокумента.СтатьяДекларацииПоЕдиномуНалогу
    |   ИЛИ ДанныеДокумента.УДАЛИТЬСуммаПоЕдиномуНалогу <> ДанныеДокумента.СуммаПоЕдиномуНалогу
	|";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
        Параметры, 
        Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
    );
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.1
Процедура ПеренестиРеквизитыПотерянныеСоответствия(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(
        Параметры.Очередь, 
        "Документ.ОтчетБанкаПоОперациямЭквайринга"
    );
	
	Пока Выборка.Следующий() Цикл
		
        НачатьТранзакцию();
        
		Попытка
            
			Блокировка = Новый БлокировкаДанных;
            
			ЭлементБлокировки = Блокировка.Добавить("Документ.ОтчетБанкаПоОперациямЭквайринга");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
            
            Блокировка.Заблокировать();
            
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				ОтменитьТранзакцию();
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				Продолжить;
            КонецЕсли;
            
            ДокументОбъект.СтатьяДекларацииПоЕдиномуНалогу = ДокументОбъект.УДАЛИТЬСтатьяДекларацииПоЕдиномуНалогу;
            ДокументОбъект.СуммаПоЕдиномуНалогу            = ДокументОбъект.УДАЛИТЬСуммаПоЕдиномуНалогу;
            
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
            ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
            ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(Выборка.Ссылка);
			ВызватьИсключение;
			
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(
        Параметры.Очередь, 
        "Документ.ОтчетБанкаПоОперациямЭквайринга"
    );
	
КонецПроцедуры


Процедура СоздатьДвиженияДенежныеСредстваВПути_ДанныеДляОбновления(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ 
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	    ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваВПути КАК ДенежныеСредстваВПути
	|	    ПО ДенежныеСредстваВПути.Регистратор = ДанныеДокумента.Ссылка
    |
	|ГДЕ
	|	ДанныеДокумента.Проведен
    |	И ДанныеДокумента.СуммаКомиссии > 0    
	|	И ДенежныеСредстваВПути.Регистратор ЕСТЬ NULL
	|
    |";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(
        Параметры, 
        Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
    );	

КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.1
// Проводит документы по регистру "Денежные средства в пути"
Процедура СоздатьДвиженияДенежныеСредстваВПути(Параметры) Экспорт
    
    ПолноеИмяОбъекта = "Документ.ОтчетБанкаПоОперациямЭквайринга"; 
    
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(
        Параметры.Очередь, 
        ПолноеИмяОбъекта
    );
    
	Пока Выборка.Следующий() Цикл
    
		НачатьТранзакцию();
		
		Попытка	
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
            ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
            ДопСвойства = Новый Структура;
            ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Выборка.Ссылка, ДопСвойства);
            ИнициализироватьДанныеДокумента(Выборка.Ссылка, ДопСвойства, "ДенежныеСредстваВПути");
            
			НаборЗаписей = РегистрыНакопления.ДенежныеСредстваВПути.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Ссылка);
            НаборЗаписей.Загрузить(ДопСвойства.ТаблицыДляДвижений["ТаблицаДенежныеСредстваВПути"]);
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
            ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
            
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
            ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(Выборка.Ссылка);
										
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
        Параметры.Очередь, 
        ПолноеИмяОбъекта
    );
    
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли

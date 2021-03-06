#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.РегламентнаяОперация) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.РегламентнаяОперация.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.РегламентнаяОперация);
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

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#Область ПроведениеПоРеглУчетуУКР
// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
		
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламетированном учете
//
Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат "";
	
КонецФункции

#КонецОбласти

// Создает и проводит документы "Регламентная операция" за указанный месяц.
//
//	Параметры:
//		Период - Дата - Начало месяца, в котором необходимо создать документы.
//		МассивОпераций - Массив - Содержит массив типов регламентных операций (значений перечисления "ТипыРегламентныхОпераций")
//		Организация - Массив, Неопределено - Список организаций по которым формируются документы. Если список пустой,
//												то документы формируются по всем организациям.
//		Отказ - Булево - Используется при вызове из формы закрытия месяца. При установке в "Истина" - дальнейшие операции
//							выполняться не будут.
Процедура РассчитатьРегламентныеОперации(Период, МассивОпераций, Организация = Неопределено, Отказ = Ложь, 
	ПроверятьНеобходимостьРаспределения = Ложь,	ПроводитьДокументы = Истина) Экспорт
	
	Если ПроверятьНеобходимостьРаспределения Тогда
		Состояние = ЗакрытиеМесяцаУТВызовСервера.СостояниеРасчетДолейСписанияКосвенныхРасходов(Организация, Период);
		Если Состояние = Перечисления.СостоянияОперацийЗакрытияМесяца.НеТребуется Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Организация) = Тип("Массив") Тогда
		МассивОрганизаций = Организация;
	ИначеЕсли ТипЗнч(Организация) = Тип("СписокЗначений") Тогда
		МассивОрганизаций = Организация.ВыгрузитьЗначения();
	Иначе
		МассивОрганизаций = Новый Массив;
		Если ЗначениеЗаполнено(Организация) Тогда
			МассивОрганизаций.Добавить(Организация);
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеСправочника.Ссылка КАК Организация,
	|	ДанныеСправочника.ОбособленноеПодразделение КАК Обособлено
	|ИЗ
	|	Справочник.Организации КАК ДанныеСправочника
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(
	|				&ДатаОкончания, 
	|				(Организация В (&МассивОрганизаций)
	|					ИЛИ &ПоВсемОрганизациям)) КАК УчетныеПолитики
	|	ПО
	|		ДанныеСправочника.Ссылка = УчетныеПолитики.Организация
	|ГДЕ
	|	(ДанныеСправочника.Ссылка В (&МассивОрганизаций)
	|		ИЛИ &ПоВсемОрганизациям)
	|	И (ДанныеСправочника.Ссылка <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	 	ИЛИ &УчитыватьУпрОрганизацию)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеглОперация.Ссылка КАК Ссылка,
	|	РеглОперация.Проведен КАК Проведен,
	|	РеглОперация.Организация КАК Организация,
	|	РеглОперация.ТипОперации КАК ТипОперации
	|ИЗ
	|	Документ.РегламентнаяОперация КАК РеглОперация
	|ГДЕ
	|	РеглОперация.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И РеглОперация.ПометкаУдаления = ЛОЖЬ
	|	И (РеглОперация.Организация В (&МассивОрганизаций)
	|	   ИЛИ &ПоВсемОрганизациям)
	|	И (РеглОперация.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|	   ИЛИ &УчитыватьУпрОрганизацию)");

	Запрос.УстановитьПараметр("ДатаНачала", 			 НачалоМесяца(Период));
	Запрос.УстановитьПараметр("ДатаОкончания", 			 КонецМесяца(Период));
	Запрос.УстановитьПараметр("УчитыватьУпрОрганизацию", ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
	Запрос.УстановитьПараметр("МассивОрганизаций", 		 МассивОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", 	 НЕ ЗначениеЗаполнено(МассивОрганизаций));
	
	Результат = Запрос.ВыполнитьПакет();

	ТаблицаОрганизации  = Результат[0].Выгрузить();
	ТаблицаДокументы = Результат[1].Выгрузить();

	Для Каждого ТипОперации Из МассивОпераций Цикл
		Для Каждого ВыборкаОрганизация Из ТаблицаОрганизации Цикл
			Если ВыборкаОрганизация.Организация = Справочники.Организации.УправленческаяОрганизация
				И (ТипОперации = Перечисления.ТипыРегламентныхОпераций.ФормированиеФинансовогоРезультата
				   ИЛИ ТипОперации = Перечисления.ТипыРегламентныхОпераций.ЗакрытиеГода) Тогда
				   Продолжить;
			ИначеЕсли ВыборкаОрганизация.Обособлено
				И (ТипОперации = Перечисления.ТипыРегламентныхОпераций.ФормированиеФинансовогоРезультата
				   ) Тогда
				   Продолжить; // Эти операции выполняются только для головной организации
			КонецЕсли;
			
			Если ТипОперации = Перечисления.ТипыРегламентныхОпераций.ФормированиеФинансовогоРезультата Тогда
				// Отменим проведение закрытия года, т.к. они оперируют одними данными
				СтруктураПоиска = Новый Структура("ТипОперации, Организация, Проведен", 
					Перечисления.ТипыРегламентныхОпераций.ЗакрытиеГода, 
					ВыборкаОрганизация.Организация,
					Истина);
				СписокСтрок = ТаблицаДокументы.НайтиСтроки(СтруктураПоиска);
				Для каждого Строка Из СписокСтрок Цикл
					ЗакрытиеГода = Строка.Ссылка.ПолучитьОбъект();
					Попытка 
						ЗакрытиеГода.Записать(РежимЗаписиДокумента.ОтменаПроведения);
						Строка.Проведен = Ложь;
					Исключение
						Отказ = Истина;
						ЗаписьЖурналаРегистрации(НСтр("ru='РегламентнаяОперация';uk='РегламентнаяОперация'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
							УровеньЖурналаРегистрации.Ошибка,,,	ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						Возврат;
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("ТипОперации,Организация", ТипОперации, ВыборкаОрганизация.Организация);
			СписокСтрок = ТаблицаДокументы.НайтиСтроки(СтруктураПоиска);
			Если СписокСтрок.Количество() = 0 Тогда
				РеглОперация = Документы.РегламентнаяОперация.СоздатьДокумент();
				РеглОперация.Дата = КонецМесяца(Период);
				РеглОперация.ТипОперации = ТипОперации;
				РеглОперация.Организация = ВыборкаОрганизация.Организация;
			Иначе
				РеглОперация = СписокСтрок[0].Ссылка.ПолучитьОбъект();
			КонецЕсли;
			Если РеглОперация.Проведен Тогда
				РеглОперация.ДополнительныеСвойства.Вставить("ОчисткаДляПоследующегоПроведения",Истина);
				Попытка 
					РеглОперация.Записать(РежимЗаписиДокумента.ОтменаПроведения)
				Исключение
					Возврат;
				КонецПопытки;
			КонецЕсли;
			РеглОперация.ДополнительныеСвойства.Вставить("ВыводитьСообщенияВЖурналРегистрации",Истина);
			РеглОперация.Записать(РежимЗаписиДокумента.Запись);
			Если ПроводитьДокументы Тогда
				Если РеглОперация.ПроверитьЗаполнение() Тогда
					Попытка
						РеглОперация.Записать(РежимЗаписиДокумента.Проведение);
					Исключение
						Отказ = Истина;
						ЗаписьЖурналаРегистрации(НСтр("ru='РегламентнаяОперация';uk='РегламентнаяОперация'"), УровеньЖурналаРегистрации.Ошибка,,,
							ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					КонецПопытки;
				Иначе
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует соответствие счетов доходов (расходов) субсчетам финансовых результатов.
//
// Возвращаемое значение:
//   Соответствие, в котором ключом является счет доходов (расходов), а значением счет финансового результата.
//
Функция ПолучитьСоответствиеСчетовДоходовИРасходовУКР() Экспорт

	// Операционная деятельность
	СоответствиеСчетов = Новый Соответствие;
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДоходыОтРеализации, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругойОперационныйДоход, 	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.МатериальныеЗатраты, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ЗатратыНаОплатуТруда, 		ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ОтчисленияНаСоциальныеМероприятия, 	
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.Амортизация, 				ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеОперационныеЗатраты, ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.СебестоимостьРеализации, 	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.АдминистративныеРасходы,	ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.РасходыНаСбыт, 			ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельностиГруппа, 
																					ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.НалогНаПрибыль,			ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);

	
	// Финансовая деятельность
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДоходОтУчастияВКапитале,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ПрочиеФинансовыеДоходы,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ФинансовыеЗатраты,			ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ПотериОтУчастияВКапитале,	ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	
	// Другая обычная деятельность
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеДоходы,				ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыПоЭлементам,	ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	СоответствиеСчетов.Вставить(ПланыСчетов.Хозрасчетный.ДругиеЗатратыДеятельности,	ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	
	
	// Всем подчиненным счетам установим такое же соответствие.
	МассивСчетов = Новый Массив;
	Для каждого Элемент Из СоответствиеСчетов Цикл
		МассивСчетов.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Хозрасчетный.Ссылка КАК Ссылка,
	               |	Хозрасчетный.Код КАК Код,
	               |	Хозрасчетный.Родитель
	               |ИЗ
	               |	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	               |
	               |ГДЕ
	               |	Хозрасчетный.Ссылка В ИЕРАРХИИ(&МассивСчетов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Хозрасчетный.Ссылка.Код
	               |
	               |ИТОГИ КОЛИЧЕСТВО(Код) ПО
	               |	Ссылка ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	ВыборкаПодчиненных = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПодчиненных.Следующий() Цикл
	
		Если СоответствиеСчетов[ВыборкаПодчиненных.Ссылка] = Неопределено 
			И СоответствиеСчетов[ВыборкаПодчиненных.Родитель] <> Неопределено Тогда
		
			СоответствиеСчетов.Вставить(ВыборкаПодчиненных.Ссылка, СоответствиеСчетов[ВыборкаПодчиненных.Родитель]);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат СоответствиеСчетов;

КонецФункции // ПолучитьСоответствиеСчетовДоходовИРасходовУКР()

// Устанавливает значение субконто в проводке по счету-назначению, если на нем есть такой же вид 
//  субконто, как и на счете-источнике.
//
// Параметры
//  СчетИсточника		– ПланСчетовСсылка – счет, откуда берется информация о субконто
//  СчетНазначение		– ПланСчетовСсылка – счет, по которому формируется проводка
//  ПроводкаСубконто	– РегистрБухгалтерииСубконто – коллекция субконто в проводке
//  НомерСубконтоИсточника - Число - номер субконто по счету источника, значение которого передается
//  ЗначениеСубконто 	- Произвольный - значение субконто для установки в проводку
//
Процедура УстановитьСовпадающееПоВидуСубконто(СчетИсточник, СчетНазначение, ПроводкаСубконто, НомерСубконтоИсточника, ЗначениеСубконто)

	Если ЗначениеСубконто = NULL Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если НомерСубконтоИсточника > СчетИсточник.ВидыСубконто.Количество() Тогда
			
		Возврат;
			
	КонецЕсли;
	
	ВидСубконто = СчетИсточник.ВидыСубконто[НомерСубконтоИсточника - 1].ВидСубконто;
	
	Если СчетНазначение.ВидыСубконто.Найти(ВидСубконто) <> Неопределено Тогда
	
		ПроводкаСубконто.Вставить(ВидСубконто, ЗначениеСубконто);
	
	КонецЕсли;

КонецПроцедуры // УстановитьСовпадающееПоВидуСубконто()

Процедура ФормированиеФинансовогоРезультатаУКР(ПараметрыРасчета, Отказ) Экспорт
	
	// Составим соответствие счетов доходов (расходов) субсчетам финансовых результатов.
	СоответствиеСчетов = ПолучитьСоответствиеСчетовДоходовИРасходовУКР();
	
	// Определим остатки на счетах доходов и расходов
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет КАК Счет,
	               |	ХозрасчетныйОстатки.Подразделение КАК Подразделение,
	               |	ХозрасчетныйОстатки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	ХозрасчетныйОстатки.Счет.Вид КАК ВидСчета,
	               |	ХозрасчетныйОстатки.Счет.Код КАК КодСчета,
	               |	ХозрасчетныйОстатки.Субконто1 КАК Субконто1,
	               |	ХозрасчетныйОстатки.Субконто2 КАК Субконто2,
	               |	ХозрасчетныйОстатки.Субконто3 КАК Субконто3,
	               |	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецМесяца, Счет В (&МассивСчетов), , Организация = &Организация) КАК ХозрасчетныйОстатки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КодСчета";
				   
	Период = КонецМесяца(ПараметрыРасчета.Дата);
	Запрос.УстановитьПараметр("КонецМесяца", Новый Граница(Период, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ПараметрыРасчета.Организация);
	
	МассивСчетов = Новый Массив;
	Для каждого Элемент Из СоответствиеСчетов Цикл
		МассивСчетов.Добавить(Элемент.Ключ);
	КонецЦикла; 
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	ПроводкиДокумента = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(ПараметрыРасчета.Ссылка);
	
	Пока ВыборкаОстатков.Следующий() Цикл
		
		СчетФинансовыхРезультатов = СоответствиеСчетов[ВыборкаОстатков.Счет];
		Если СчетФинансовыхРезультатов = Неопределено Тогда
			Продолжить;			
		КонецЕсли;
		
		Если ВыборкаОстатков.ВидСчета = ВидСчета.Активный Тогда
			
			Проводка = ПроводкиДокумента.Добавить();
			Проводка.Период                    = Период;
			Проводка.Организация               = ПараметрыРасчета.Организация;
			
			Проводка.СчетДт                    = СчетФинансовыхРезультатов;
			Проводка.ПодразделениеДт		   = ВыборкаОстатков.Подразделение;
			Проводка.НаправлениеДеятельностиДт = ВыборкаОстатков.НаправлениеДеятельности;
			// Стараемся "передать" информацию о субконто из доходов (расходов) в фин. рез-ты
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.СчетКт                    = ВыборкаОстатков.Счет;
			Проводка.ПодразделениеКт		   = ВыборкаОстатков.Подразделение;
			Проводка.НаправлениеДеятельностиКт = ВыборкаОстатков.НаправлениеДеятельности;
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.Сумма                     = ВыборкаОстатков.СуммаОстаток;
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: закрытие расходов';uk='Фінансові результати: закриття витрат'",Локализация.КодЯзыкаИнформационнойБазы());
			
		Иначе
			
			Проводка = ПроводкиДокумента.Добавить();
			Проводка.Период                    = Период;
			Проводка.Организация               = ПараметрыРасчета.Организация;
			
			Проводка.СчетДт                    = ВыборкаОстатков.Счет;
			Проводка.ПодразделениеДт		   = ВыборкаОстатков.Подразделение;
			Проводка.НаправлениеДеятельностиДт = ВыборкаОстатков.НаправлениеДеятельности;
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетДт, Проводка.СубконтоДт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.СчетКт                    = СчетФинансовыхРезультатов;
			Проводка.ПодразделениеКт		   = ВыборкаОстатков.Подразделение;
			Проводка.НаправлениеДеятельностиКт = ВыборкаОстатков.НаправлениеДеятельности;
			// Стараемся "передать" информацию о субконто из доходов (расходов) в фин. рез-ты
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 1, ВыборкаОстатков.Субконто1);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 2, ВыборкаОстатков.Субконто2);
			УстановитьСовпадающееПоВидуСубконто(ВыборкаОстатков.Счет, Проводка.СчетКт, Проводка.СубконтоКт, 3, ВыборкаОстатков.Субконто3);
			
			Проводка.Сумма                     = - ВыборкаОстатков.СуммаОстаток;
			
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: закрытие доходов';uk='Фінансові результати: закриття доходів'",Локализация.КодЯзыкаИнформационнойБазы());
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	ПроводкиДокумента.Записать();
		
КонецПроцедуры // ФормированиеФинансовогоРезультатаУКР

// Возвращает массив со счетами финансовых результатов
// 				и использованной прибыли
//
// Возвращаемое значение:
//   Массив 
//
Функция ПолучитьМассивСчетовФинансовыхРезультатов()

	МассивСчетов = Новый Массив;
	
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатОперационнойДеятельности);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатДругойОбычнойДеятельности);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РезультатФинансовыхОпераций);
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.ПрибыльИспользованнаяВОтчетномПериоде);
	
	Возврат МассивСчетов;
	
КонецФункции // ПолучитьМассивСчетовФинансовыхРезультатов()

Процедура ЗакрытиеГодаУКР(ПараметрыРасчета, Отказ) Экспорт
	
	// Определим остатки на счетах финансовых результатов и использованной прибыли
	
	// Определим остатки на счетах
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХозрасчетныйОстатки.Счет КАК Счет,
	               |	ХозрасчетныйОстатки.Подразделение КАК Подразделение,
	               |	ХозрасчетныйОстатки.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	ХозрасчетныйОстатки.СуммаОстатокДт КАК СуммаОстатокДт,
	               |	ХозрасчетныйОстатки.СуммаОстатокКт КАК СуммаОстатокКт
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(&КонецМесяца, Счет В (&МассивСчетов), , Организация = &Организация) КАК ХозрасчетныйОстатки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ХозрасчетныйОстатки.Счет.Код";
				   
	Период = КонецМесяца(ПараметрыРасчета.Дата);
	Запрос.УстановитьПараметр("КонецМесяца", Новый Граница(Период, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ПараметрыРасчета.Организация);
	МассивСчетов = ПолучитьМассивСчетовФинансовыхРезультатов();
	Запрос.УстановитьПараметр("МассивСчетов", МассивСчетов);
	
	ТаблицаОстатков = Запрос.Выполнить().Выгрузить();
	
	ФинансовыйРезультат = ТаблицаОстатков.Итог("СуммаОстатокДт") - ТаблицаОстатков.Итог("СуммаОстатокКт");
	
	СчетПрибылиУбытка = Неопределено;
	Если ФинансовыйРезультат < 0 Тогда
		
		// Прибыль
		СчетПрибылиУбытка = ПланыСчетов.Хозрасчетный.НераспределеннаяПрибыль;
		
	Иначе
		
		// Убыток
		СчетПрибылиУбытка = ПланыСчетов.Хозрасчетный.НепокрытыйУбыток;
		
	КонецЕсли;
	
	ПроводкиДокумента = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(ПараметрыРасчета.Ссылка);

	// Закрываем все остатки на счет прибыли (убытка)
	Для каждого СтрокаОстатка Из ТаблицаОстатков Цикл
		
		Остаток = СтрокаОстатка.СуммаОстатокДт - СтрокаОстатка.СуммаОстатокКт;
		
		Если Остаток > 0 Тогда
		
			Проводка = ПроводкиДокумента.Добавить();
			Проводка.Период                    = Период;
			Проводка.Организация               = ПараметрыРасчета.Организация;
			Проводка.СчетДт                    = СчетПрибылиУбытка;
			
			Проводка.СчетКт                    = СтрокаОстатка.Счет;
			Проводка.ПодразделениеКт		   = СтрокаОстатка.Подразделение;
			Проводка.НаправлениеДеятельностиКт = СтрокаОстатка.НаправлениеДеятельности;
			
			Проводка.Сумма                     = Остаток;
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: формирование прибыли/убытка';uk='Фінансові результати: формування прибутку/збитку'",Локализация.КодЯзыкаИнформационнойБазы());
			
		Иначе
			
			Проводка = ПроводкиДокумента.Добавить();
			Проводка.Период                    = Период;
			Проводка.Организация               = ПараметрыРасчета.Организация;
			
			Проводка.СчетДт                    = СтрокаОстатка.Счет;
			Проводка.ПодразделениеДт		   = СтрокаОстатка.Подразделение;
			Проводка.НаправлениеДеятельностиДт = СтрокаОстатка.НаправлениеДеятельности;
			
			Проводка.СчетКт                    = СчетПрибылиУбытка;
			
			Проводка.Сумма                     = -Остаток;
			Проводка.Содержание                = НСтр("ru='Финансовые результаты: формирование прибыли/убытка';uk='Фінансові результати: формування прибутку/збитку'",Локализация.КодЯзыкаИнформационнойБазы());
		
		КонецЕсли; 
	
	КонецЦикла; 

	ПроводкиДокумента.Записать();
		
КонецПроцедуры // ЗакрытиеГодаУКР

// Прочее

Функция ТаблицыПроведения(НомераТаблиц, Результат)
	
	ТаблицыПроведения = Новый Структура;
	
	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		Если НРег(Лев(НомерТаблицы.Ключ, 7)) = "таблица" Тогда
			ТаблицыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицыПроведения;
	
КонецФункции

#Область НЕУКР
// Расчет резервов по сомнительным долгам
 
Функция ПодготовитьПараметрыРезервыПоСомнительнымДолгам(СтруктураШапки, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ГоловноеПодразделение = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(СтруктураШапки.Организация);
	Если ЗначениеЗаполнено(ГоловноеПодразделение) Тогда
		ОрганизацияДляУчетнойПолитики = ГоловноеПодразделение;
	Иначе
		ОрганизацияДляУчетнойПолитики = СтруктураШапки.Организация;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка",              СтруктураШапки.Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала",             НачалоМесяца(СтруктураШапки.Дата));
	Запрос.УстановитьПараметр("ДатаОкончания",             КонецМесяца(СтруктураШапки.Дата));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОрганизацияДляУчетнойПолитики);
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(ОрганизацияДляУчетнойПолитики);
	Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
	Запрос.УстановитьПараметр("Граница", Новый Граница(КонецМесяца(СтруктураШапки.Дата), ВидГраницы.Включая));
	ТипыСубконто = Новый Массив;
	ТипыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ТипыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	Запрос.УстановитьПараметр("ТипыСубконто", ТипыСубконто);
	
	УстановитьПривилегированныйРежим(Истина);

	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРезервыПоСомнительнымДолгам(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ПараметрыПроведения = ТаблицыПроведения(НомераТаблиц, Результат);
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаРезервыПоСомнительнымДолгам(НомераТаблиц)
	
	// Временные таблицы
	НомераТаблиц.Вставить("ТаблицаРеквизитыРезервыПоСомнительнымДолгам", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РегламентнаяОперация.Ссылка КАК Регистратор,
	|	РегламентнаяОперация.Организация КАК Организация,
	|	РегламентнаяОперация.Дата КАК Период,
	|	КОНЕЦПЕРИОДА(РегламентнаяОперация.Дата, МЕСЯЦ) КАК КонДата
	|ИЗ
	|	Документ.РегламентнаяОперация КАК РегламентнаяОперация
	|ГДЕ
	|	РегламентнаяОперация.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

#КонецОбласти 

// Расчет курсовых разниц

Процедура РасчетКурсовыхРазниц(ПараметрыРасчета, Отказ) Экспорт
	
	Период = КонецМесяца(ПараметрыРасчета.Дата);
	Запрос = Новый Запрос(ТекстЗапросаРасчетКурсовыхРазниц());
	Запрос.УстановитьПараметр("Организация", ПараметрыРасчета.Организация);
	Запрос.УстановитьПараметр("ГраницаОстатков", Новый Граница(Период, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НаДату", Период);

	ПроводкиДокумента = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(ПараметрыРасчета.Ссылка);
	
	ВидСубконтоСтатьиДДС = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиДвиженияДенежныхСредств;
	СтатьяДДСПрибыль = Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыПрибыль;
	СтатьяДДСУбыток = Справочники.СтатьиДвиженияДенежныхСредств.КурсовыеРазницыУбыток;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Проводка = ПроводкиДокумента.Добавить();
		Проводка.Активность = Истина;
		Проводка.Период = Период;
		Проводка.Организация = ПараметрыРасчета.Организация;
		
		СуммаРазницы = Макс(Выборка.КурсоваяРазница, -Выборка.КурсоваяРазница);
		Если Выборка.КурсоваяРазница > 0 Тогда// отразим прибыль
			Счет = "Дт";
			Кор = "Кт";
			КорСчет = Выборка.СчетДоходов;
			КорСубконто = Выборка.СтатьяДоходов;
			КорВидСубконто = Выборка.ВидСубконтоДоходы;
			СтатьяДДС = СтатьяДДСПрибыль;
			
		Иначе// отразим убытки
			Счет = "Кт";
			Кор = "Дт";
			КорСчет = Выборка.СчетРасходов;
			КорСубконто = Выборка.СтатьяРасходов;
			КорВидСубконто = Выборка.ВидСубконтоРасходы;
			СтатьяДДС = СтатьяДДСУбыток;
			
		КонецЕсли;
		
		// заполним счет и аналитику возникновения курсовой разницы
		Проводка["Счет"+Счет] = Выборка.Счет;
		Проводка["Валюта"+Счет] = Выборка.Валюта;
		Проводка["Подразделение"+Счет] = Выборка.Подразделение;
		Проводка["НаправлениеДеятельности"+Счет] = Выборка.НаправлениеДеятельности;
		ВидыСубконто = Выборка.ВидыСубконтоСчета.Выгрузить();
		Для Каждого стр Из ВидыСубконто Цикл
			Проводка["Субконто" + Счет][стр.ВидСубконто] = Выборка["Субконто"+стр.НомерСтроки];
			Если стр.ВидСубконто = ВидСубконтоСтатьиДДС И стр.ТолькоОбороты Тогда
				Проводка["Субконто" + Счет][стр.ВидСубконто] = СтатьяДДС;
			КонецЕсли;
		КонецЦикла;
		
		// заполним счет учета прибыли\убытка от курсовой разницы
		Проводка["Счет" + Кор] = КорСчет;
		Проводка["Подразделение"+Кор] = Выборка.Подразделение;
		Проводка["НаправлениеДеятельности"+Кор] = Неопределено;
		Если ЗначениеЗаполнено(КорВидСубконто) Тогда
			Проводка["Субконто" + Кор][КорВидСубконто] = КорСубконто;	
		КонецЕсли;
		
		Проводка.Сумма = СуммаРазницы;
		
	КонецЦикла;// по валютным остаткам
	
	ПроводкиДокумента.Записать();
	
КонецПроцедуры

Функция ТекстЗапросаРасчетКурсовыхРазниц()
	
	
	Возврат
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Период,
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ПОМЕСТИТЬ втКурсы
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&НаДату, ) КАК КурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// Счета учета расчетов с поставщиками
	|ВЫБРАТЬ
	|	ПланСчетов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ втСчетаАвтоматизированногоУчета
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК ПланСчетов
	|ГДЕ
	|	ПланСчетов.Ссылка В ИЕРАРХИИ (
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками),
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками),
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСДругимиКредиторами),
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСДругимиДебиторами),
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоВыданнымАвансам),
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоАвансамПолученным)
	|		)
	|	И ПланСчетов.ВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
	|	И ПланСчетов.ВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)
	|	И Не ПланСчетов.Забалансовый
	|	И Не ПланСчетов.ЗапретитьИспользоватьВПроводках
	|
	|	
	| ОБЪЕДИНИТЬ ВСЕ 
	|/////////////////////////////////////////////////////////////////////////////
	|// Другие автоматизированные счета
	|ВЫБРАТЬ
	|	ПланСчетов.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК ПланСчетов
	|ГДЕ
	|	ПланСчетов.Ссылка В ИЕРАРХИИ 
	|		(ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицамиВИностраннойВалюте),
	|		 ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.КраткосрочныеКредитыБанковВИностраннойВалюте),
	|		 ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДолгосрочныеКредитыБанковВИностраннойВалюте),
	|		 ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ТекущаяЗадолженностьПоДолгосрочнымОбязательствамВИностраннойВалюте)
	|		 )
	|	И Не ПланСчетов.ЗапретитьИспользоватьВПроводках
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.Счет,
	|	Остатки.Организация,
	|	Остатки.Подразделение,
	|	Остатки.НаправлениеДеятельности,
	|	Остатки.Счет.ВидыСубконто КАК ВидыСубконтоСчета,
	|	Остатки.Счет.Валютный КАК СчетВалютный,
	|	Остатки.Счет.НалоговыйУчет КАК НалоговыйУчет,
	|	Остатки.Субконто1,
	|	Остатки.Субконто2,
	|	Остатки.Субконто3,
	|	Остатки.Валюта,
	|	Остатки.ВалютнаяСуммаОстаток КАК ОстатокВалюты,
	|	Остатки.СуммаОстаток КАК ОстатокРегл,
	|	Остатки.ВалютнаяСуммаОстаток * втКурсы.Курс / втКурсы.Кратность КАК ОстатокПоКурсу,
	|	Остатки.ВалютнаяСуммаОстаток * втКурсы.Курс / втКурсы.Кратность - Остатки.СуммаОстаток КАК АбсолютнаяРазница,
	|	ВЫРАЗИТЬ(Остатки.ВалютнаяСуммаОстаток * втКурсы.Курс / втКурсы.Кратность КАК ЧИСЛО(15,2)) - Остатки.СуммаОстаток КАК КурсоваяРазница,
	|

	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДругойДополнительныйКапитал)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходОтОперационнойКурсовойРазницы) 
	|	КОНЕЦ КАК СчетДоходов,
	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы) 
	|	КОНЕЦ КАК СтатьяДоходов,
	|	
	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДругойДополнительныйКапитал)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ЗатратыОтОперационнойКурсовойРазницы) 
	|	КОНЕЦ КАК СчетРасходов,
	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.КурсовыеРазницы) 
	|	КОНЕЦ КАК СтатьяРасходов,
	|	
	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиДоходов) 
	|	КОНЕЦ КАК ВидСубконтоДоходы,
	|	ВЫБОР КОГДА Остатки.Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НеоплаченныйКапитал)) 
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат) 
	|	КОНЕЦ КАК ВидСубконтоРасходы
	|
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&ГраницаОстатков,
	|			Счет.Валютный И НЕ Счет.ИсключитьИзПереоценкиПоПлануСчетов
	|			И Счет НЕ В (ВЫБРАТЬ Ссылка ИЗ втСчетаАвтоматизированногоУчета),
	|			,
	|			Организация = &Организация) КАК Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКурсы КАК втКурсы
	|		ПО Остатки.Валюта = втКурсы.Валюта
	|ГДЕ
	|	ВЫРАЗИТЬ(Остатки.ВалютнаяСуммаОстаток * втКурсы.Курс / втКурсы.Кратность КАК ЧИСЛО(15,2)) <> Остатки.СуммаОстаток";
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
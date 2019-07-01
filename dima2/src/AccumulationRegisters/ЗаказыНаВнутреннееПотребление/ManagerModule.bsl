#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Склад)          КАК Склад,
		|	МАКСИМУМ(РегистрЗаказы.Серия)          КАК Серия,
		|	СУММА(РегистрЗаказы.КОформлению) КАК Количество
		|ИЗ
		|	ВтОтбор КАК Отбор
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыНаВнутреннееПотребление КАК РегистрЗаказы
		|		ПО РегистрЗаказы.ЗаказНаВнутреннееПотребление = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

//Возвращает текст запроса заказанного количества из заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказанного по заказам количества.
//
//Параметры:
//	ЕстьФильтр - Булево - Признак, определяющий необходимость предварительной фильтрации выборки по заказам,
//	                      передаваемым параметром "Заказы".
//
//Возвращаемое значение:
//	Строка - Текст запроса.
//
Функция ТекстЗапросаЗаказовКОбеспечению(ЕстьФильтр) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Т.ЗаказНаВнутреннееПотребление КАК Заказ,
		|	Т.КодСтроки                    КАК КодСтроки,
		|	Т.ЗаказаноОстаток - Т.КОформлениюОстаток КАК Количество
		|ПОМЕСТИТЬ ВтРегистрЗаказыНаВнутреннееПотребление
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(,
		|		{Склад.* КАК Склад,
		|		ЗаказНаВнутреннееПотребление.* КАК Заказ} ЗаказНаВнутреннееПотребление В (&Заказы)) КАК Т
		|ГДЕ
		|	Т.ЗаказаноОстаток > Т.КОформлениюОстаток
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Заказ, КодСтроки
		|;
		|
		|////////////////////////////////////////////
		|";

	Если Не ЕстьФильтр Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " ЗаказНаВнутреннееПотребление В (&Заказы)", "");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

//Возвращает текст запроса заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказов,
//содержащих указанную номенклатуру на указанном складе.
//
//Возвращаемое значение:
// Строка - текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры() Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Т.ЗаказНаВнутреннееПотребление КАК Заказ
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(,
		|		{Склад.* КАК Склад, Номенклатура.* КАК Номенклатура}) КАК Т
		|ГДЕ
		|	Т.ЗаказаноОстаток > Т.КОформлениюОстаток";

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область Состояния

// Возвращает текст запроса для расчета количества товара которое осталось отгрузить
// 
// Возвращаемое значение:
//   - Строка
//
Функция ВременнаяТаблицаОстаткиЗаказов() Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ЗаказНаВнутреннееПотребление КАК Распоряжение,
		|	Таблица.ЗаказаноОстаток              КАК КоличествоЗаказано
		|ПОМЕСТИТЬ ВтОстаткиЗаказов
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(, ЗаказНаВнутреннееПотребление В(&МассивЗаказов)) КАК Таблица";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

Функция РаспоряженияРМВнутреннееТовародвижение(Склад, РаспоряженияДляПересчета = Неопределено) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.ЗаказНаВнутреннееПотребление КАК Ссылка,
	|	Таблица.Склад,
	|	Таблица.КОформлениюРасход,
	|	Таблица.КОформлениюПриход,
	|// ПРОВЕРКА НА ОТСУТСТВИЕ НЕОБХОДИМОСТИ В ОРДЕРЕ
	|	ВЫБОР
	|		КОГДА Склады.Ссылка ЕСТЬ NULL ТОГДА
	|		4 // ОРДЕРА НЕ ИСПОЛЬЗУЮТСЯ
	|		ИНАЧЕ
	|		0 // ОРДЕРНАЯ СХЕМА. ЗНАЧЕНИЕ ПО УМОЛЧАНИЮ
	|	КОНЕЦ КАК СостояниеОрдера
	|ПОМЕСТИТЬ втДанныеРегистраПоДокументуВЦелом
	|ИЗ
	|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.ОстаткиИОбороты() КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО Таблица.Склад = Склады.Ссылка
	|			И (Склады.ИспользоватьОрдернуюСхемуПриОтгрузке)
	|			И (Склады.ДатаНачалаОрдернойСхемыПриОтгрузке <= &НачалоТекущегоДня)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|Ссылка
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.ЗаказНаВнутреннееПотребление КАК Ссылка,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Склад,
	|	Таблица.Серия,
	|	ВЫБОР
	|// В ЦЕЛОМ ПО ДОКУМЕНТУ БЫЛО СПИСАНИЕ ПО РЕСУРСУ КОФОРМЛЕНИЮ И КОНКРЕТНАЯ СТРОКА ПОЛНОСТЬЮ ОФОРМЛЕНА
	|		КОГДА Таблица.КОформлениюКонечныйОстаток = 0
	|			И ЕСТЬNULL(ДанныеДокумента.КОформлениюРасход, 0) > 0
	|			ТОГДА 0
	|// В ЦЕЛОМ ПО ДОКУМЕНТУ БЫЛО СПИСАНИЕ ПО РЕСУРСУ КОФОРМЛЕНИЮ
	|		КОГДА ЕСТЬNULL(ДанныеДокумента.КОформлениюРасход, 0) > 0
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК СостояниеНакладной,
	|	ДанныеДокумента.СостояниеОрдера КАК СостояниеОрдера
	|ПОМЕСТИТЬ втДанныеРегистра
	|ИЗ
	|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.ОстаткиИОбороты() КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеРегистраПоДокументуВЦелом КАК ДанныеДокумента
	|		ПО Таблица.ЗаказНаВнутреннееПотребление = ДанныеДокумента.Ссылка
	|		И Таблица.Склад = ДанныеДокумента.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТИПЗНАЧЕНИЯ(втДанныеРегистра.Ссылка) КАК Тип,
	|	втДанныеРегистра.Ссылка,
	|	втДанныеРегистра.Склад,
	|	МАКСИМУМ(втДанныеРегистра.СостояниеНакладной) КАК СостояниеНакладной,
	|	МАКСИМУМ(втДанныеРегистра.СостояниеОрдера) КАК СостояниеОрдера,
	|	4 КАК СостояниеПриходногоОрдера // Внутреннее потребление не предполагает приемки на склад, есть только отгрузка.
	|ИЗ
	|	втДанныеРегистра КАК втДанныеРегистра
	|
	|СГРУППИРОВАТЬ ПО
	|	ТИПЗНАЧЕНИЯ(втДанныеРегистра.Ссылка),
	|	втДанныеРегистра.Ссылка,
	|	втДанныеРегистра.Склад
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(втДанныеРегистра.СостояниеНакладной) > 0";
	
	ТекстУсловийЗапроса = "";
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ТекстУсловия = "Склад = &Склад";
		ТекстУсловийЗапроса = ТекстУсловийЗапроса + ТекстУсловия;
		Запрос.УстановитьПараметр("Склад", Склад);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РаспоряженияДляПересчета) Тогда
		ТекстУсловия = "ЗаказНаВнутреннееПотребление В (&Распоряжения)";
		ТекстУсловийЗапроса = ТекстУсловийЗапроса + ?(ЗначениеЗаполнено(ТекстУсловийЗапроса), " И " + ТекстУсловия, ТекстУсловия);
		Запрос.УстановитьПараметр("Распоряжения", РаспоряженияДляПересчета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстУсловийЗапроса) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОстаткиИОбороты(", "ОстаткиИОбороты(" + ", , , , " + ТекстУсловийЗапроса);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	
	Если ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыНаВнутреннееПотребление) Тогда
		Результат = Запрос.Выполнить().Выгрузить();
		Возврат Результат;
	Иначе
		Возврат Новый ТаблицаЗначений();
	КонецЕсли;
	
КонецФункции

// Возвращает остаток к оформлению по переданному списку заказов
//
// Параметры:
//  МассивЗаказов	 - Массив					 - Массив заказов
//  Склад			 - СправочникСсылка.Склады	 - 
// 
// Возвращаемое значение:
//   - ТаблицаЗначений
//
Функция КОформлениюОстатокРМВнутреннееТовародвижение(МассивЗаказов, Склад = Неопределено) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Заказы", МассивЗаказов);
	Запрос.УстановитьПараметр("Склад",  Склад);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказыНаВнутреннееПотреблениеОстатки.ЗаказНаВнутреннееПотребление,
	|	ЗаказыНаВнутреннееПотреблениеОстатки.Номенклатура,
	|	ЗаказыНаВнутреннееПотреблениеОстатки.Характеристика,
	|	ЗаказыНаВнутреннееПотреблениеОстатки.КодСтроки,
	|	ЗаказыНаВнутреннееПотреблениеОстатки.Серия,
	|	ЗаказыНаВнутреннееПотреблениеОстатки.КОформлениюОстаток КАК Количество
	|ПОМЕСТИТЬ ВтДанныеРегистра
	|ИЗ
	|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(, 
	|		ЗаказНаВнутреннееПотребление В (&Заказы)
	|		//%Отбор
	|		) КАК ЗаказыНаВнутреннееПотреблениеОстатки";
	
	Запрос.Текст = Запрос.Текст + ТекстРазделителяЗапросов();
	
	НужноОбъединение = Ложь;
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказНаВнутреннееПотребление) Тогда
		
		НужноОбъединение = Истина;
		
		Запрос.Текст = Запрос.Текст + 
		"ВЫБРАТЬ
		|	ДанныеРегистра.ЗаказНаВнутреннееПотребление,
		|	ДанныеРегистра.Номенклатура,
		|	ДанныеРегистра.Характеристика,
		|	ВЫБОР КОГДА Таблица.ВариантОбеспечения В(
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно),
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)) ТОГДА
		|				Таблица.Ссылка.Назначение
		|			ИНАЧЕ
		|				ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|		КОНЕЦ                         КАК Назначение,
		|	ДанныеРегистра.КодСтроки,
		|	ДанныеРегистра.Серия,
		|	ДанныеРегистра.Количество КАК Количество
		|ИЗ
		|	ВтДанныеРегистра КАК ДанныеРегистра
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаВнутреннееПотребление.Товары КАК Таблица
		|			ПО ДанныеРегистра.ЗаказНаВнутреннееПотребление = Таблица.Ссылка
		|			 И ДанныеРегистра.КодСтроки = Таблица.КодСтроки";
		
	КонецЕсли;
	
//++ НЕ УТКА
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказНаРемонт) Тогда
		
		Если НужноОбъединение Тогда
			Запрос.Текст = Запрос.Текст + 
			"
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
	
		Запрос.Текст = Запрос.Текст + 
		"ВЫБРАТЬ
		|	ДанныеРегистра.ЗаказНаВнутреннееПотребление,
		|	ДанныеРегистра.Номенклатура,
		|	ДанныеРегистра.Характеристика,
		|	ВЫБОР КОГДА Таблица.ВариантОбеспечения В(
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно),
		|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)) ТОГДА
		|			Таблица.Ссылка.Назначение
		|		ИНАЧЕ
		|			ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
		|	КОНЕЦ                         КАК Назначение,
		|	ДанныеРегистра.КодСтроки,
		|	ДанныеРегистра.Серия,
		|	ДанныеРегистра.Количество КАК Количество
		|ИЗ
		|	ВтДанныеРегистра КАК ДанныеРегистра
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаРемонт.МатериалыИРаботы КАК Таблица
		|			ПО ДанныеРегистра.ЗаказНаВнутреннееПотребление = Таблица.Ссылка
		|			 И ДанныеРегистра.КодСтроки = Таблица.КодСтроки";
		
	КонецЕсли;
//-- НЕ УТКА
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//%Отбор", "И Склад = &Склад");
	КонецЕсли;
	
	КодыСтрокЗаказов = Запрос.Выполнить().Выгрузить();
	
	Возврат КодыСтрокЗаказов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстРазделителяЗапросов()

	ТекстРазделителя =
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстРазделителя;

КонецФункции

#Область ОбновлениеИнформационнойБазы


Процедура ИсправитьДвижения_ДанныеДляОбновления(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ЗаказыНаВнутреннееПотребление";
	ИмяРегистра       = "ЗаказыНаВнутреннееПотребление";
	
#Область ВнутреннееПотреблениеТоваров

	ТекстЗапросаАдаптированный = Документы.ВнутреннееПотреблениеТоваров.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
																										
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(ТекстЗапросаАдаптированный,
																				ПолноеИмяРегистра,
																				"Документ.ВнутреннееПотреблениеТоваров");
																					
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);

#КонецОбласти

#Область ЗаказНаВнутреннееПотребление

	ТекстЗапросаАдаптированный = Документы.ЗаказНаВнутреннееПотребление.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
																										
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(ТекстЗапросаАдаптированный,
																				ПолноеИмяРегистра,
																				"Документ.ЗаказНаВнутреннееПотребление");
																					
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);

#КонецОбласти

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК ТЧДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВнутреннееПотреблениеТоваров КАК ШапкаДокумента
	|		ПО ТЧДокумента.Ссылка = ШапкаДокумента.Ссылка
	|ГДЕ
	|	ШапкаДокумента.Проведен
	|	И (ТЧДокумента.СтатусУказанияСерий = 10
	|				И ТЧДокумента.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			ИЛИ ТЧДокумента.КодСтроки = 0
	|				И ТЧДокумента.ЗаказНаВнутреннееПотребление В (&ПустыеЗначенияЗаказов)
	|				И ШапкаДокумента.ПотреблениеПоЗаказам)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТЧДокумента.Ссылка
	|ИЗ
	|	Документ.ЗаказНаВнутреннееПотребление.Товары КАК ТЧДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказНаВнутреннееПотребление КАК ШапкаДокумента
	|		ПО ТЧДокумента.Ссылка = ШапкаДокумента.Ссылка
	|ГДЕ
	|	(ТЧДокумента.СтатусУказанияСерий = 10
	|				И ТЧДокумента.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|			ИЛИ ТЧДокумента.СтатусУказанияСерий В (11, 15)
	|				И ТЧДокумента.ВариантОбеспечения В (ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить), ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
	|				И ШапкаДокумента.Проведен)";
	
	
	Запрос.УстановитьПараметр("ПустыеЗначенияЗаказов", Документы.ВнутреннееПотреблениеТоваров.ПустыеЗначенияЗаказов());
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ЗаказыНаВнутреннееПотребление";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
	                                                Регистраторы,
	                                                ДополнительныеПараметры);
	
	
КонецПроцедуры

// Обработчик обновления BAS УТ 3.2.3
Процедура ИсправитьДвижения(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВнутреннееПотреблениеТоваров");
	Регистраторы.Добавить("Документ.ЗаказНаВнутреннееПотребление");
	
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
	                                                                                  "РегистрНакопления.ЗаказыНаВнутреннееПотребление",
	                                                                                  Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
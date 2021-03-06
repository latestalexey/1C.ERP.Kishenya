#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в заказе поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	ВалютаВзаиморасчетов = УсловияЗакупок.Валюта;
	НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Склад) Тогда
		Склад = УсловияЗакупок.Склад;
		СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
		Если СтруктураОтветственного <> Неопределено Тогда
			Принял = СтруктураОтветственного.Ответственный;
			ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
		
		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
			ЭтотОбъект,
			Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика,
			ВалютаВзаиморасчетов);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаОплаты = УсловияЗакупок.ФормаОплаты;
	
	ЗначениеДатыПлатежа = ЗакупкиСервер.ПолучитьПоследнююДатуПоГрафику(Дата, УсловияЗакупок.Соглашение);
	Если ЗначениеЗаполнено(ЗначениеДатыПлатежа) Тогда
		ДатаПлатежа = ЗначениеДатыПлатежа;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЦенаВключаетНДС         = УсловияЗакупок.ЦенаВключаетНДС;
	ПредусмотренЗалогЗаТару = УсловияЗакупок.ТребуетсяЗалогЗаТару;
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию(ПересчитатьЦены = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			Новый Структура("ВыбранноеСоглашение", Соглашение));
		
		ЦеныЗаполнены = Ложь;
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
			
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
				Если ПересчитатьЦены И ЗначениеЗаполнено(Соглашение) Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					ЦеныЗаполнены = ЗакупкиСервер.ЗаполнитьЦены(
						Товары,
						, // Массив строк
						Новый Структура( // Параметры заполнения
							"ПоляЗаполнения, Дата, Валюта, Соглашение",
							"Цена, СтавкаНДС, ВидЦеныПоставщика",
							Дата,
							Валюта,
							Соглашение
						),
						Новый Структура( // Структура действий с измененныими строками
							"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС, ПересчитатьСуммуРучнойСкидки, ПересчитатьСуммуСУчетомРучнойСкидки",
							"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Новый Структура("Очищать", Ложь)));
					
				КонецЕсли;
								
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в заказе поставщику
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа
//
Процедура ЗаполнитьУсловияЗакупокПоCоглашению(ПересчитатьЦены = Истина) Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение, Истина, Истина);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	
	Если ПересчитатьЦены Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		ЗакупкиСервер.ЗаполнитьЦены(
			Товары,
			, // Массив строк
			Новый Структура( // Параметры заполнения
				"ПоляЗаполнения, Дата, Валюта, Соглашение",
				"Цена, СтавкаНДС, ВидЦеныПоставщика",
				Дата,
				Валюта,
				Соглашение
			),
			Новый Структура( // Структура действий с измененныими строками
				"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
				"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Новый Структура("Очищать", Ложь)));
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	Если ПредусмотренЗалогЗаТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаВзаиморасчетов");
	КонецЕсли;
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	
	//++ НЕ УТКА
	ВозвратТарыДавальцу = Ложь;
	Для Каждого Строка Из Товары Цикл 
		Если ТипЗнч(Строка.ДокументПоступления) = Тип("ДокументСсылка.ПоступлениеСырьяОтДавальца") Тогда
			ВозвратТарыДавальцу = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ПредусмотренЗалогЗаТару И ВозвратТарыДавальцу Тогда
		ТекстОшибки = НСтр("ru='Залог не используется для тары, полученной от давальца.';uk='Застава не використовується для тари, отриманої від давальця.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ПредусмотренЗалогЗаТару",
			,
			Отказ);
	КонецЕсли;
	//-- НЕ УТКА
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЗакупкиСервер.ПроверитьКорректностьЗаполненияДокументаЗакупки(ЭтотОбъект,Отказ);
																		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Перем СкладПоступления;
	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПринятойТаре") Тогда
			ЗаполнитьДокументНаОснованииПринятойТары(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ЗаполнитьДокументНаОснованииПоступленияТоваровУслуг(ДанныеЗаполнения);
	//++ НЕ УТКА
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеСырьяОтДавальца") Тогда
		ЗаполнитьДокументНаОснованииПоступлениеСырьяОтДавальца(ДанныеЗаполнения);
	//-- НЕ УТКА
	КонецЕсли;

	ИнициализироватьДокумент();
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВПоступлении(ЭтотОбъект, "Товары");
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Товары");
	ВзаиморасчетыСервер.ЗаполнитьСуммуНДСВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Товары");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
		ЗаполнитьАналитикуУчетаНоменклатуры();
	КонецЕсли;
	
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ВыкупВозвратнойТарыУПоставщика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	МногооборотнаяТараСервер.ОтразитьПринятуюВозвратнуюТару(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьКорректировкиНДСПартий(ДополнительныеСвойства, Движения, Отказ);
	НДСИсходящийСервер.ОтразитьНДСУсловныеПродажи(ДополнительныеСвойства, Движения, Отказ);
		
	
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ДатаПлатежа     = Дата(1,1,1);
	Согласован      = Ложь;
	ВидЗапасов      = Неопределено;
	ДатаВходящегоДокумента = Дата(1,1,1);
	НомерВходящегоДокумента = "";
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка ИЛИ ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииПринятойТары(Знач РеквизитыЗаполнения)
	
	Если РеквизитыЗаполнения.РеквизитыШапки.Свойство("Соглашение", Соглашение) И ЗначениеЗаполнено(Соглашение) Тогда
		ЗаполнитьУсловияЗакупокПоCоглашению(Ложь);
	Иначе
		ЗаполнитьУсловияЗакупокПоУмолчанию(Ложь);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения.РеквизитыШапки);
	
	
	Если ЭтоАдресВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище) Тогда
		
		ПринятаяТара = ПолучитьИзВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище);
		Товары.Загрузить(ПринятаяТара);
		
		
		ОрганизацияПлательщикНДС = НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Организация, Дата);
		
		Для каждого ТекущаяСтрока Из Товары Цикл
			
			ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
			ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
			
			Если ОрганизацияПлательщикНДС Тогда
				ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
			Иначе
				ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;
			КонецЕсли; 
 
			Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПоступленияТоваровУслуг(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслуг.Ссылка                       КАК ДокументОснование,
		|	ПоступлениеТоваровУслуг.Валюта                       КАК Валюта,
		|	ПоступлениеТоваровУслуг.Партнер                      КАК Партнер,
		|	ПоступлениеТоваровУслуг.Соглашение                   КАК Соглашение,
		|	ПоступлениеТоваровУслуг.Организация                  КАК Организация,
		|	ПоступлениеТоваровУслуг.Контрагент                   КАК Контрагент,
		|	ПоступлениеТоваровУслуг.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
		|	ПоступлениеТоваровУслуг.ВалютаВзаиморасчетов         КАК ВалютаВзаиморасчетов,
		|	ПоступлениеТоваровУслуг.ФормаОплаты                  КАК ФормаОплаты,
		|	ПоступлениеТоваровУслуг.ТребуетсяЗалогЗаТару         КАК ПредусмотренЗалогЗаТару,
		|	ПоступлениеТоваровУслуг.ПорядокРасчетов              КАК ПорядокРасчетов,
		|	НЕ ПоступлениеТоваровУслуг.Проведен                  КАК ЕстьОшибкиПроведен,
		|	НЕ ПоступлениеТоваровУслуг.ВернутьМногооборотнуюТару КАК ЕстьОшибкиВернутьМногооборотнуюТару,
		|	ПоступлениеТоваровУслуг.НаправлениеДеятельности      КАК НаправлениеДеятельности
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|ГДЕ
		|	ПоступлениеТоваровУслуг.Ссылка = &ДокументОснование
		|;
		|ВЫБРАТЬ
		|	ПринятаяВозвратнаяТараОстатки.Номенклатура        КАК Номенклатура,
		|	ПринятаяВозвратнаяТараОстатки.Характеристика      КАК Характеристика,
		|	ПринятаяВозвратнаяТараОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ПринятаяВозвратнаяТараОстатки.СуммаОстаток        КАК Сумма,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК Количество,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК КоличествоУпаковок
		|ИЗ
		|	РегистрНакопления.ПринятаяВозвратнаяТара.Остатки(, ДокументПоступления = &ДокументОснование) КАК ПринятаяВозвратнаяТараОстатки
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	УстановитьПривилегированныйРежим(Истина);
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = ПакетЗапросов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииВыкупаТары(
		ДокументОснование,
		ВыборкаШапка.ЕстьОшибкиПроведен,
		ВыборкаШапка.ЕстьОшибкиВернутьМногооборотнуюТару);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(ПакетЗапросов[1].Выгрузить());
	
	
	ОрганизацияПлательщикНДС = НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Организация, Дата);
	
	Для каждого ТекущаяСтрока Из Товары Цикл
		
		ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
		ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
		
		Если ОрганизацияПлательщикНДС Тогда
			ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
		Иначе
			ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;
		КонецЕсли;
		
		Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры

//++ НЕ УТКА
Процедура ЗаполнитьДокументНаОснованииПоступлениеСырьяОтДавальца(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоступлениеСырья.Ссылка                       КАК ДокументОснование,
		|	ПоступлениеСырья.Валюта                       КАК Валюта,
		|	ПоступлениеСырья.Партнер                      КАК Партнер,
		|	ПоступлениеСырья.Организация                  КАК Организация,
		|	ПоступлениеСырья.Контрагент                   КАК Контрагент,
		|	ПоступлениеСырья.ТребуетсяЗалогЗаТару         КАК ПредусмотренЗалогЗаТару,
		|	НЕ ПоступлениеСырья.Проведен                  КАК ЕстьОшибкиПроведен,
		|	НЕ ПоступлениеСырья.ВернутьМногооборотнуюТару КАК ЕстьОшибкиВернутьМногооборотнуюТару
		|ИЗ
		|	Документ.ПоступлениеСырьяОтДавальца КАК ПоступлениеСырья
		|ГДЕ
		|	ПоступлениеСырья.Ссылка = &ДокументОснование
		|;
		|ВЫБРАТЬ
		|	ПринятаяВозвратнаяТараОстатки.Номенклатура        КАК Номенклатура,
		|	ПринятаяВозвратнаяТараОстатки.Характеристика      КАК Характеристика,
		|	ПринятаяВозвратнаяТараОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ПринятаяВозвратнаяТараОстатки.СуммаОстаток        КАК Сумма,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК Количество,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК КоличествоУпаковок
		|ИЗ
		|	РегистрНакопления.ПринятаяВозвратнаяТара.Остатки(, ДокументПоступления = &ДокументОснование) КАК ПринятаяВозвратнаяТараОстатки
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	УстановитьПривилегированныйРежим(Истина);
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = ПакетЗапросов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииВыкупаТары(
		ДокументОснование,
		ВыборкаШапка.ЕстьОшибкиПроведен,
		ВыборкаШапка.ЕстьОшибкиВернутьМногооборотнуюТару);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(ПакетЗапросов[1].Выгрузить());
	
	
	ОрганизацияПлательщикНДС = НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Организация, Дата);
	
	Для каждого ТекущаяСтрока Из Товары Цикл
		
		ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
		ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
		
		Если ОрганизацияПлательщикНДС Тогда
			ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
		Иначе
			ТекущаяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;
		КонецЕсли;
		Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры
//-- НЕ УТКА

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияЗакупокПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент()
	
	Менеджер                  = Пользователи.ТекущийПользователь();
	Валюта                    = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ВалютаВзаиморасчетов      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПорядокРасчетов           = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ПринятаяВозвратнаяТара);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ЗаполнитьАналитикуУчетаНоменклатуры()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
    |	ТаблицаТоваров.НомерСтроки	КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
    |	ТаблицаТоваров.Характеристика КАК Характеристика,
    |	ТаблицаТоваров.ДокументПоступления КАК ДокументПоступления
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
    |
    |;
    |ВЫБРАТЬ
    |	ТаблицаТоваровДокумента.НомерСтроки	КАК НомерСтроки,
    |	ТаблицаТоваровДокумента.Номенклатура КАК Номенклатура,
    |	ТаблицаТоваровДокумента.Характеристика КАК Характеристика,
    |	ЕСТЬNULL(Склады.Ссылка, ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК Склад
    |	
    |ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
    |ИЗ
    |	ТаблицаТоваровДокумента КАК ТаблицаТоваровДокумента
    |
    |	ЛЕВОЕ СОЕДИНЕНИЕ
    |		Справочник.Склады КАК Склады
    |		ПО ТаблицаТоваровДокумента.ДокументПоступления.Склад = Склады.Ссылка
    |;
    |
	|ВЫБРАТЬ
	|	ИсходнаяТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ИсходнаяТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ИсходнаяТаблицаТоваров.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
    |	ИсходнаяТаблицаТоваров.Склад КАК Склад
	|ИЗ
	|	ИсходнаяТаблицаТоваров КАК ИсходнаяТаблицаТоваров
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
    
    Запрос.УстановитьПараметр(
        "ТаблицаТоваров", 
        Товары.Выгрузить(,"НомерСтроки, Номенклатура, Характеристика, ДокументПоступления")
    );
    
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
        
        Параметры = Новый Структура("Номенклатура, Характеристика, Серия, Склад", 
			Выборка.Номенклатура, Выборка.Характеристика, Выборка.Серия, Выборка.Склад);
		
		СтрокаТоваров = Товары.Найти(Выборка.НомерСтроки, "НомерСтроки");
		СтрокаТоваров.АналитикаУчетаНоменклатуры = РегистрыСведений.АналитикаУчетаНоменклатуры.ЗначениеКлючаАналитики(Параметры);
        
	КонецЦикла;  
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

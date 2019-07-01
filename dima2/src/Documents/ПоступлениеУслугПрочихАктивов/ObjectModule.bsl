#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если НЕ НДСОбщегоНазначенияСервер.КонтрагентПлательщикНДС(Контрагент) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Расходы.СтавкаНДС");
	КонецЕсли; 
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ПоступлениеУслугПрочихАктивов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	
	Если МассивНепроверяемыхРеквизитов.Найти("Расходы.АналитикаРасходов") = Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, Новый Структура("Расходы"), МассивНепроверяемыхРеквизитов, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);

	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
    ДополнительныеСвойства.Вставить("НеобходимостьЗаполненияСчетаПриФОИспользоватьНесколькоСчетовЛожь", Ложь);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если НЕ НДСОбщегоНазначенияСервер.КонтрагентПлательщикНДС(Контрагент) Тогда
		
		Для Каждого ТекСтрока Из Расходы Цикл
			ТекСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НеНДС;
		КонецЦикла;
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(ЭтотОбъект);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Расходы, СтруктураДействий, Неопределено);
		
	КонецЕсли; 
	
	НДСОбщегоНазначенияСервер.ЗаполнитьНалоговыеНазначенияВТабличныхЧастяхПередЗаписьюДокументаПоступление(
		ЭтотОбъект,
		"Расходы"
	);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Расходы, ЦенаВключаетНДС);
	
	ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВПоступлении(ЭтотОбъект, "Расходы");
	Ценообразование.РассчитатьСуммыВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Расходы");
	ВзаиморасчетыСервер.ЗаполнитьСуммуНДСВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, "Расходы");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Расходы);
		ЗаполнитьКлючиАналитикиУчетаПартийДокумента();
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЗапасыСервер.ОчиститьАналитикуУчетаПартийВТабличнойЧасти(Расходы);
	КонецЕсли;
	
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(Расходы, "СтатьяРасходов");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ПоступлениеУслугПрочихАктивов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	НДСВходящийСервер.ОтразитьНДССоставПоставкиДляРегистрацииВходящихНалоговыхДокументов(ДополнительныеСвойства, Движения, Отказ);
	НДСВходящийСервер.ОтразитьНДСРасчетНалоговогоКредита(ДополнительныеСвойства, Движения, Отказ);
	
	//++ НЕ УТ
	// Движения по регистрам регламентированного учета.
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
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

	ИнициализироватьДокумент();
	
	ДатаПлатежа				= Дата(1,1,1);
	ДатаВходящегоДокумента	= Дата(1,1,1);
	НомерВходящегоДокумента	= "";
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Заполняет условия закупок в документе.
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта               = УсловияЗакупок.Валюта;
	ВалютаВзаиморасчетов = УсловияЗакупок.Валюта;
	НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация    			= Организация;
		СтруктураПараметров.НаправлениеДеятельности	= НаправлениеДеятельности;
		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
	КонецЕсли;
	
	Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда

		Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
			ЭтотОбъект,
			ХозяйственнаяОперация,
		ВалютаВзаиморасчетов
	);
	
		ЗакупкиВызовСервера.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") Тогда
			НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
		КонецЕсли;
	
	КонецЕсли;
	
	ЗначениеДатыПлатежа = ЗакупкиСервер.ПолучитьПоследнююДатуПоГрафику(Дата, УсловияЗакупок.Соглашение);
	Если ЗначениеЗаполнено(ЗначениеДатыПлатежа) Тогда
		ДатаПлатежа = ЗначениеДатыПлатежа;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЦенаВключаетНДС      = УсловияЗакупок.ЦенаВключаетНДС;
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком.
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию() Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		ПараметрыОтбора = Новый Структура("УчитыватьГруппыСкладов, ИсключитьГруппыСкладовДоступныеВЗаказах, ХозяйственныеОперации, ВыбранноеСоглашение",
			Истина,
			Истина,
			Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика,
			Соглашение);
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			ПараметрыОтбора);
			
		ЦеныЗаполнены = Ложь;
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
				
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			Соглашение = Неопределено;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер = Пользователи.ТекущийПользователь();
	
    Валюта                    = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
    ВалютаВзаиморасчетов      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаВзаиморасчетов);	
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение             = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Организация;
	СтруктураПараметров.БанковскийСчет		= БанковскийСчетОрганизации;
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
	ПорядокРасчетов           = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ДатаПлатежа = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(Расходы, "СтатьяРасходов");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);

КонецПроцедуры

Процедура ЗаполнитьКлючиАналитикиУчетаПартийДокумента() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки			КАК НомерСтроки,
	|	ТаблицаТоваров.СтатьяРасходов		КАК СтатьяРасходов,
	|	ТаблицаТоваров.СтавкаНДС			КАК СтавкаНДС,
	|	ТаблицаТоваров.НалоговоеНазначение	КАК НалоговоеНазначение,
	|	ТаблицаТоваров.АналитикаУчетаПартий	КАК АналитикаУчетаПартий
	|
	|ПОМЕСТИТЬ ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НалоговоеНазначение							КАК НалоговоеНазначение,
	|	ТаблицаТоваров.НомерСтроки									КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)				КАК Номенклатура,
	|	ТаблицаТоваров.СтавкаНДС									КАК СтавкаНДС,
	|	&Поставщик													КАК Поставщик,
	|	&Контрагент													КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)	КАК АналитикаУчетаПартий
	|
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровДокумента КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПартий КАК Аналитики
	|	ПО
	|		ТаблицаТоваров.АналитикаУчетаПартий = Аналитики.КлючАналитики
	|
	|ГДЕ
	|	Аналитики.КлючАналитики ЕСТЬ NULL");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	СтрокиТЧ = "НомерСтроки, СтавкаНДС, НалоговоеНазначение, АналитикаУчетаПартий, СтатьяРасходов";
	
	Запрос.УстановитьПараметр("ТаблицаТоваров",		Расходы.Выгрузить(, СтрокиТЧ));
	Запрос.УстановитьПараметр("Поставщик",			Партнер);
	Запрос.УстановитьПараметр("Контрагент",			Контрагент);
	
	Запрос.Выполнить();
	
	ПартионныйУчетСервер.ЗаполнитьАналитикуУчетаПартийВТабличнойЧастиТовары(МенеджерВременныхТаблиц, Расходы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

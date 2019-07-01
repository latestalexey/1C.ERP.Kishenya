#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Менеджер = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И ДанныеЗаполнения.Свойство("ЗаполнятьПоТоварамКОформлению") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Соглашение = ДанныеЗаполнения.Соглашение;
		Договор = ДанныеЗаполнения.Договор;
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
		КонецПериода = ДанныеЗаполнения.КонецПериода;
		Если НачалоМесяца(КонецПериода) < НачалоМесяца(ТекущаяДата()) Тогда
			Дата = КонецПериода;
		КонецЕсли;
		Если ЗначениеЗаполнено(Соглашение) Тогда
			ЗаполнитьУсловияЗакупокПоCоглашению();
			Организация = ДанныеЗаполнения.Организация;
		Иначе
			Валюта = ДанныеЗаполнения.Валюта;
			Организация = ДанныеЗаполнения.Организация;
			Если Не ЗначениеЗаполнено(Контрагент) Тогда
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			КонецЕсли;
			МассивХозяйственныхОпераций = Новый Массив;
			МассивХозяйственныхОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссию"));
			МассивХозяйственныхОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссиюИмпорт"));
			Если Не ЗначениеЗаполнено(Договор) Тогда
				Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
					ЭтотОбъект,
					МассивХозяйственныхОпераций,
					Валюта);
			КонецЕсли;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
		
		КомиссионнаяТорговляСервер.ЗаполнитьТоварыПоОстаткамКОформлениюОтчетовКомитентуОСписании(
			ЭтотОбъект,
			НДСОбщегоНазначенияСервер.ПолучитьНалогообложениеНДС(Организация, Контрагент, Дата, Истина) // НалогообложениеНДС
		);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	ВзаиморасчетыСервер.ПроверитьДатуПлатежа(ЭтотОбъект, Отказ);
	КомиссионнаяТорговляСервер.ПроверитьКорректностьПериода(ЭтотОбъект, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию;
	Если ЗначениеЗаполнено(НаправлениеДеятельности) 
		ИЛИ НЕ НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(КонецПериода)
	 И НачалоМесяца(Дата) <> НачалоМесяца(КонецПериода) Тогда
	 	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Дата документа и дата окончания периода %1 должны быть в одном месяце';uk='Дата документа та дата закінчення періоду %1 повинні бути в одному місяці'"),
			Формат(КонецПериода, "ДЛФ=DD"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Дата",
			, // Путь к данным
			Отказ);
	КонецЕсли;
																							
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	РасчетСуммаДокумента = Товары.Итог("СуммаСНДС");
	Если СуммаДокумента <> РасчетСуммаДокумента Тогда
		СуммаДокумента = РасчетСуммаДокумента;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.ОтчетКомитенту, Неопределено, Подразделение, Партнер);
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.СтатусУказанияСерий = "";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);

		ЗаполнитьВидыЗапасов(Отказ);
		ЗаполнитьКлючиАналитикиУчетаПартийДокумента();
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
	КонецЕсли;
	
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ОтчетКомитентуОСписании.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ПартионныйУчетСервер.ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
		
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	
	УправленческийУчетПроведениеСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок <> Неопределено Тогда
	
		ДокументЗакупки = ЭтотОбъект;
		ДокументЗакупки.Валюта = УсловияЗакупок.Валюта;
		НаправлениеДеятельности = УсловияЗакупок.НаправлениеДеятельности;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.Организация) Тогда
			ДокументЗакупки.Организация = УсловияЗакупок.Организация;
		КонецЕсли;
			
		Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) Тогда
			ДокументЗакупки.Контрагент = УсловияЗакупок.Контрагент;
		КонецЕсли;
		
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		
		Если УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов <> Неопределено И УсловияЗакупок.ИспользуютсяДоговорыКонтрагентов Тогда
			МассивХозяйственныхОпераций = Новый Массив;
			МассивХозяйственныхОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссию"));
			МассивХозяйственныхОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссиюИмпорт"));
			
			Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
				ЭтотОбъект,
				МассивХозяйственныхОпераций,
				Валюта);
				
			Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности") Тогда
				НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
			КонецЕсли;
		
		КонецЕсли;
		
		ДокументЗакупки.ЦенаВключаетНДС = УсловияЗакупок.ЦенаВключаетНДС;
		
		Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
			ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьУсловияЗакупокПоCоглашению(ПересчитатьЦены = Истина) Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	
	Если ПересчитатьЦены Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		ЗакупкиСервер.ЗаполнитьЦены(
			Товары,
			, // Массив строк
			Новый Структура( // Параметры заполнения
				"ПоляЗаполнения, Дата, Валюта, Соглашение",
				"Цена, СтавкаНДС",
				Дата,
				Валюта,
				Соглашение
			),
			Новый Структура( // Структура действий с измененныими строками
				"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
				"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
	КонецЕсли;
	
	КомиссионнаяТорговляСервер.ЗаполнитьСуммуСНДС(Товары, ЦенаВключаетНДС);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация     = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
    Валюта          = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ПорядокРасчетов = ВзаиморасчетыСервер.ПорядокРасчетовПоДокументу(ЭтотОбъект);
	
	ПредставительОрганизации          = Менеджер.ФизическоеЛицо;
	ПредставительОрганизацииДолжность = ДолжностиДляПечатиКлиентСервер.ДолжностьФизическогоЛица(ПредставительОрганизации, Организация, Дата);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	 ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличествуИСумме(МенеджерВременныхТаблиц) Тогда
	 
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ТаблицаОстатковКОформлениюОтчетаКомитентуОСписании(МенеджерВременныхТаблиц);
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок,
			Отказ);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, СтавкаНДС, ЦелевоеНалоговоеНазначение", "Количество, СуммаСНДС, СуммаНДС");
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Партнер КАК Партнер,
	|	&Контрагент КАК Контрагент,
	|	&Соглашение КАК Соглашение,
	|	&Договор КАК Договор,
	|	&Валюта КАК Валюта,
	|	&НалоговоеНазначениеОрганизации КАК НалоговоеНазначениеОрганизации,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетКомитентуОСписании) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.НалоговоеНазначениеСписания КАК ЦелевоеНалоговоеНазначение,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов
	|	
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(Товары.Выгрузить()));
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(ВидыЗапасов.Выгрузить()));
	Запрос.УстановитьПараметр("НалоговоеНазначениеОрганизации", НДСОбщегоНазначенияСервер.ПолучитьНалоговоеНазначениеНДС(Организация, Контрагент, Дата, Истина));
	Запрос.УстановитьПараметр("ОрганизацияПлательщикНДС",       НДСОбщегоНазначенияСервер.ОрганизацияПлательщикНДС(Организация, Дата));
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Функция РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) КАК НачалоМесяца,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Партнер,
	|	ДанныеДокумента.Соглашение,
	|	ДанныеДокумента.Валюта
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.ОтчетКомитентуОСписании КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Партнер <> СохраненныеДанные.Партнер ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Соглашение <> СохраненныеДанные.Соглашение ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Валюта <> СохраненныеДанные.Валюта ТОГДА
	|		Истина
	|	КОГДА НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) <> СохраненныеДанные.НачалоМесяца ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК РеквизитыИзменены
	|ИЗ
	|	ТаблицаДанныхДокумента КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СохраненныеДанныеДокумента КАК СохраненныеДанные
	|	ПО
	|		Истина
	|");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РеквизитыИзменены = Выборка.РеквизитыИзменены;
	Иначе
		РеквизитыИзменены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца
	|
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.Комитент = &Партнер
	|	И ВидыЗапасов.Соглашение = &Соглашение
	|	И ВидыЗапасов.Валюта = &Валюта
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ТаблицаОстатковКОформлениюОтчетаКомитентуОСписании(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОрганизаций.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТоварыОрганизаций.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	НЕОПРЕДЕЛЕНО КАК ДокументРеализации,
	|	ТоварыОрганизаций.ВидЗапасов КАК ВидЗапасов,
	|	ТоварыОрганизаций.ВидЗапасов КАК ВидЗапасовВладельца,
	|	ТоварыОрганизаций.ВидЗапасов.НалоговоеНазначение КАК НалоговоеНазначение,
	|	Неопределено КАК ВидЗапасовПолучателя,
	|	Неопределено КАК ВидЗапасовОтгрузки,
	|	Ложь КАК РеализацияЗапасовДругойОрганизации,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ТоварыОрганизаций.НомерГТД КАК НомерГТД,
	|	МАКСИМУМ(ТоварыОрганизаций.ДатаПоступления) КАК ДатаПоступления,
	|	СУММА(ТоварыОрганизаций.Количество) КАК КоличествоОстаток,
	|	СУММА(ТоварыОрганизаций.СуммаВыручки) КАК СуммаОстаток
	|
	|ПОМЕСТИТЬ ТаблицаОстатков
	|ИЗ (
	|	ВЫБРАТЬ // ВидыЗапасов, списанные документом
	|		ТоварыКОформлению.ВидЗапасов.Организация КАК Организация,
	|		ТоварыКОформлению.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыКОформлению.ВидЗапасов КАК ВидЗапасов,
	|		ТоварыКОформлению.НомерГТД КАК НомерГТД,
	|		ТоварыКОформлению.КоличествоСписано КАК Количество,
	|		0 КАК СуммаВыручки,
	|
	|		ДатыПередачиТоваровНаКомиссию.ДатаПередачи КАК ДатаПоступления
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту КАК ТоварыКОформлению
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ДатыПередачиТоваровНаКомиссию КАК ДатыПередачиТоваровНаКомиссию
	|		ПО
	|			ТоварыКОформлению.ВидЗапасов = ДатыПередачиТоваровНаКомиссию.ВидЗапасов
	|			И ТоварыКОформлению.АналитикаУчетаНоменклатуры = ДатыПередачиТоваровНаКомиссию.АналитикаУчетаНоменклатуры
	|			И ТоварыКОформлению.НомерГТД = ДатыПередачиТоваровНаКомиссию.НомерГТД
	|			И ТоварыКОформлению.ВидЗапасов.Соглашение = ДатыПередачиТоваровНаКомиссию.Соглашение
	|			И ТоварыКОформлению.ВидЗапасов.Организация = ДатыПередачиТоваровНаКомиссию.Организация
	|	ГДЕ
	|		ТоварыКОформлению.Регистратор = &Ссылка
	|		И ТоварыКОформлению.Активность
	|		И ТоварыКОформлению.ВидЗапасов В (
	|			ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				ДоступныеВидыЗапасов.ВидЗапасов
	|			ИЗ
	|				ДоступныеВидыЗапасов КАК ДоступныеВидыЗапасов
	|			)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ // Списанные виды запасов
	|		ТоварыКОформлению.ВидЗапасов.Организация КАК Организация,
	|		ТоварыКОформлению.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыКОформлению.ВидЗапасов КАК ВидЗапасов,
	|		ТоварыКОформлению.НомерГТД КАК НомерГТД,
	|		ТоварыКОформлению.КоличествоСписаноПриход - ТоварыКОформлению.КоличествоСписаноРасход КАК Количество,
	|		0 КАК СуммаВыручки,
	|
	|		ДатыПередачиТоваровНаКомиссию.ДатаПередачи КАК ДатаПоступления
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту.Обороты(&НачалоПериода, &КонецПериода, Период,
	|			Валюта = &Валюта
	|			И ВидЗапасов В (
	|				ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ДоступныеВидыЗапасов.ВидЗапасов
	|				ИЗ
	|					ДоступныеВидыЗапасов КАК ДоступныеВидыЗапасов
	|				)
	|			И (АналитикаУчетаНоменклатуры) В (
	|				ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|				ИЗ
	|					ТаблицаТоваров КАК ТаблицаТоваров
	|				)
	|		) КАК ТоварыКОформлению
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ДатыПередачиТоваровНаКомиссию КАК ДатыПередачиТоваровНаКомиссию
	|		ПО
	|			ТоварыКОформлению.ВидЗапасов = ДатыПередачиТоваровНаКомиссию.ВидЗапасов
	|			И ТоварыКОформлению.АналитикаУчетаНоменклатуры = ДатыПередачиТоваровНаКомиссию.АналитикаУчетаНоменклатуры
	|			И ТоварыКОформлению.НомерГТД = ДатыПередачиТоваровНаКомиссию.НомерГТД
	|			И ТоварыКОформлению.ВидЗапасов.Соглашение = ДатыПередачиТоваровНаКомиссию.Соглашение
	|			И ТоварыКОформлению.ВидЗапасов.Организация = ДатыПередачиТоваровНаКомиссию.Организация
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ // Виды запасов, указанные в документе вручную.
	|		Запасы.ВидЗапасов.Организация КАК Организация,
	|		Запасы.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Запасы.ВидЗапасов КАК ВидЗапасов,
	|		Запасы.НомерГТД КАК НомерГТД,
	|		Запасы.Количество КАК Количество,
	|		0 КАК СуммаВыручки,
	|		ДАТАВРЕМЯ(1,1,1) КАК ДатаПоступления
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК Запасы
	|	ГДЕ
	|		Запасы.ВидыЗапасовУказаныВручную
	|		И (Запасы.АналитикаУчетаНоменклатуры) В (
	|			ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|			ИЗ
	|				ТаблицаТоваров КАК ТаблицаТоваров
	|			)
	|
	|	) КАК ТоварыОрганизаций
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТоварыОрганизаций.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыОрганизаций.Организация,
	|	ТоварыОрганизаций.АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия,
	|	ТоварыОрганизаций.ВидЗапасов,
	|	ТоварыОрганизаций.НомерГТД
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("НачалоПериода", ?(ЗначениеЗаполнено(НачалоПериода), НачалоПериода, НачалоМесяца(Дата)));
	Запрос.УстановитьПараметр("КонецПериода", ?(ЗначениеЗаполнено(КонецПериода), КонецДня(КонецПериода), КонецМесяца(Дата)));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок)
	
	Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Номенклатура: %1 
            |Отчет комитенту превышает остаток списанного товара организацией %2 по соглашению %3 на %4 %5'
            |;uk='Номенклатура: %1 
            |Звіт комітенту перевищує залишок списаного товару організацією %2 за офертою %3 на %4 %5'"),
			НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
			Организация,
			Соглашение,
			СтрокаТаблицы.Количество,
			СтрокаТаблицы.ЕдиницаИзмерения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьКлючиАналитикиУчетаПартийДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.ЦелевоеНалоговоеНазначение КАК НалоговоеНазначениеСписания,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаПартий	КАК АналитикаУчетаПартий
	|ПОМЕСТИТЬ ТаблицаТоваровДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	| 	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	НЕОПРЕДЕЛЕНО КАК Поставщик,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|   ТаблицаТоваров.НалоговоеНазначениеСписания КАК НалоговоеНазначение, 
	|	ТаблицаТоваров.АналитикаУчетаПартий
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ТаблицаТоваровДокумента КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.АналитикаУчетаПартий = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|");
	                	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров", ВидыЗапасов.Выгрузить(, 
		"НомерСтроки, ЦелевоеНалоговоеНазначение, АналитикаУчетаНоменклатуры, АналитикаУчетаПартий"));		
				
	Запрос.Выполнить();
	
	ПартионныйУчетСервер.ЗаполнитьАналитикуУчетаПартийВТабличнойЧастиТовары(МенеджерВременныхТаблиц, ВидыЗапасов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

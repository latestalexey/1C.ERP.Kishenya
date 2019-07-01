#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	МассивНесогласованныхСтатусов = Новый Массив;
	МассивНесогласованныхСтатусов.Добавить(Перечисления.СтатусыНалоговыхДокументов.КПроверке);
	МассивНесогласованныхСтатусов.Добавить(Перечисления.СтатусыНалоговыхДокументов.Сформирован);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(
		ЭтотОбъект,
		РежимЗаписи,
		МассивНесогласованныхСтатусов);
	
	Если СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ФормироватьПриложение2 Тогда
		РазрешенаАвтоКорректировка = Ложь;
	Иначе
		РазрешенаАвтоКорректировка = Истина;
	КонецЕсли;
	
	ЭтоУсловнаяПродажа = (ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.УсловнаяПродажа
		Или ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.СводнаяУсловнаяПродажа);
	
	Если НалоговаяНакладнаяНеЗарегистрированаВИБ И ЗначениеЗаполнено(НалоговаяНакладная) Тогда
		НалоговаяНакладная = Неопределено;
	КонецЕсли;
	Если НЕ НалоговаяНакладнаяНеЗарегистрированаВИБ И (ЗначениеЗаполнено(НалоговаяНакладнаяНомер) ИЛИ ЗначениеЗаполнено(НалоговаяНакладнаяДата)) Тогда
		НалоговаяНакладнаяНомер = Неопределено;
		НалоговаяНакладнаяДата = Неопределено;
	КонецЕсли;
	
	Если НЕ НалоговаяНакладнаяНеЗарегистрированаВИБ И ЗначениеЗаполнено(ОбособленноеПодразделение) Тогда
		ОбособленноеПодразделение = НалоговаяНакладная.ОбособленноеПодразделение;
	КонецЕсли;
	
	Если ЭтоУсловнаяПродажа
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ПродажаНижеОбычнойЦены
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ИтоговаяРозницаОблагаемыеОперации
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ИтоговаяРозницаОсвобожденныеОперации Тогда
		ОчиститьВзаиморасчеты = Истина;
	Иначе
		ОчиститьВзаиморасчеты = Ложь;
	КонецЕсли;
	
	Если ЭтоУсловнаяПродажа
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ПродажаНижеОбычнойЦены
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.РаботыОтНерезидента Тогда
		ОбъектРасчетов = Неопределено;
	КонецЕсли;
	
	Если ОчиститьВзаиморасчеты Тогда
		Контрагент = Неопределено;
		Партнер = Неопределено;
		Договор = Неопределено;
		Если ТипЗнч(ОбъектРасчетов) <> Тип("ПеречислениеСсылка.СтавкиНДС") Тогда
			ОбъектРасчетов = Неопределено;
		КонецЕсли;
		ДатаДоговора = Неопределено;
		НомерДоговора = Неопределено;
		ВидДоговора = Неопределено;
	КонецЕсли;
	
	Если ЭтоУсловнаяПродажа Тогда
		Сводная = Истина;
	КонецЕсли;
	
	Если ЭтоУсловнаяПродажа
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ПродажаНижеОбычнойЦены
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.РаботыОтНерезидента Тогда
		Товары.Очистить();
	КонецЕсли;
	
	Если НЕ СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ Тогда
		ТоварыПоДаннымПользователя.Очистить();
	КонецЕсли;

	ТабличныеЧасти = Новый Массив;
	ТабличныеЧасти.Добавить("Товары");
	ТабличныеЧасти.Добавить("ТоварыПоДаннымПользователя");
	Для каждого ИмяТабличнойЧасти Из ТабличныеЧасти Цикл
		Для каждого СтрокаТовары Из ЭтотОбъект[ИмяТабличнойЧасти] Цикл
			// Это обычный товар или услуга
			Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) И ЗначениеЗаполнено(СтрокаТовары.ЕдиницаИзмерения) Тогда
				СтрокаТовары.ЕдиницаИзмерения = Неопределено;	
			КонецЕсли;
			// Это прочий актив
			Если Не ЗначениеЗаполнено(СтрокаТовары.Номенклатура) И ЗначениеЗаполнено(СтрокаТовары.Упаковка) Тогда
				СтрокаТовары.Упаковка = Неопределено;	
			КонецЕсли;
		КонецЦикла;		
	КонецЦикла;

// Для табличной части "ТоварыПоДаннымПользователя"
	НаименованиеОчищаемыхРеквизитов = Новый Массив;
	
	Если НЕ ЭтоУсловнаяПродажа Тогда
		НаименованиеОчищаемыхРеквизитов.Добавить("НалоговоеНазначение");
		НаименованиеОчищаемыхРеквизитов.Добавить("НалоговоеНазначениеПоФактуУсловнаяПродажа");
		НаименованиеОчищаемыхРеквизитов.Добавить("ОбъектЗаполненияСодержанияУсловнаяПродажа");
	КонецЕсли;
	
	Для каждого СтрокаТовары Из ТоварыПоДаннымПользователя Цикл
		Для Каждого ЭлементМассива Из НаименованиеОчищаемыхРеквизитов Цикл
			Если ЗначениеЗаполнено(СтрокаТовары[СокрЛП(ЭлементМассива)]) Тогда
				СтрокаТовары[СокрЛП(ЭлементМассива)] = Неопределено;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;		
	
	Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		Партнер = Справочники.Партнеры.НашеПредприятие;
	КонецЕсли;

	ЗаполнитьСуммыРеглВТабличныхЧастях();
	
	Если СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ Тогда
		СуммаДокумента = ТоварыПоДаннымПользователя.Итог("СуммаСНДС");
	Иначе
		СуммаДокумента = Товары.Итог("СуммаСНДС");
	КонецЕсли;	
	
	// поставим флаг "Требует регистрация в реестре"
	Если Дата >= '2015-01-01' Тогда
		ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
		ЭлектронныйДокумент = Истина;
	ИначеЕсли ЗначениеЗаполнено(НалоговаяНакладная) И НалоговаяНакладная.ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных Тогда
		
		ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
		
	Иначе
		
		Если ТипПричиныНевыдачиПокупателю >= 1
			И Дата >= '2014-03-01' Тогда
			
			ЭлектронныйДокумент = Ложь;
		    ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Ложь;
			
		КонецЕсли;
		
		Если ТипПричиныНевыдачиПокупателю > 0 Тогда
			// мы не управляем флажком ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных
			// для налоговых накладных, которые не выдаются покупателю
			// согласно разъяснению ЕБНЗ такие налоговые не должны регистрироваться в Едином реестре
			
		ИначеЕсли ЭлектронныйДокумент Тогда
			
			ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
			
		Иначе	
			
			ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Ложь;
		
			Если СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ Тогда
				НДСРегл = ТоварыПоДаннымПользователя.Итог("СуммаНДСРегл");
			Иначе
				НДСРегл = Товары.Итог("СуммаНДСРегл");
			КонецЕсли;
			
			Если Дата >= '20120101' Тогда
				// или сумма НДС в документе больше 10 000 грн
				Если НДСРегл > 10000 Тогда
					ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
					
				// или имеются подакцизные/импортированные товары
				// этот факт определим так - если в строке указан код УКТЗЭД - считаем что условие выполняется.
				ИначеЕсли   Товары.НайтиСтроки(Новый Структура("НомерГТД", Справочники.НоменклатураГТД.ПустаяСсылка())).Количество() 	<> Товары.Количество() Тогда
					ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
				КонецЕсли;
			ИначеЕсли Дата >= '20110701' Тогда
				// сумма НДС в документе больше 100 000 грн
				Если НДСРегл > 100000 Тогда
					ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
				КонецЕсли;
			ИначеЕсли Дата >= '20110401' Тогда
				// сумма НДС в документе больше 500 000 грн
				Если НДСРегл > 500000 Тогда
					ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
				КонецЕсли;
			ИначеЕсли Дата >= '20110101' Тогда
				// сумма НДС в документе больше 1 000 000 грн
				Если НДСРегл > 1000000 Тогда
					ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина;
				КонецЕсли;
			КонецЕсли;
			
			Если ТребуетВключенияВЕдиныйРеестрНалоговыхНакладных = Истина
			   И ЗначениеЗаполнено(НалоговаяНакладная)
			   И НалоговаяНакладная.СтатусРегистрацииВЕРНН = Перечисления.СтатусыРегистрацииВЕРНННалоговыхДокументов.НеЗарегистрированВЕРНН Тогда
			   
			   Сообщить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Перед выгрузкой документа: %1 в Единый реестр налоговых накладных"
"необходимо также зарегистрировать исходную налоговую накладную: %2!';uk='Перед вивантаженням документа: %1 до Єдиного реєстра податкових накладних"
"необхідно також зареєструвати в ньому податкову накладну: %2!'"), Ссылка, НалоговаяНакладная), СтатусСообщения.Важное);
			   
			КонецЕсли;
			
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДоступенФлагПереоценка =  
		 (ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ОблагаемыеОперации ИЛИ
	      ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ОсвобожденныеОперации ИЛИ
	      ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.НеНДСОперации) И 
		 (ВидОперацииВозвратКорректировка = Перечисления.ВидыОперацийПриложений2КНалоговойНакладной.Корректировка);		  
	Если Не ДоступенФлагПереоценка Тогда		  
		Переоценка = Ложь;	
	КонецЕсли;	

	Если '2014-12-01' <= Дата  Тогда
		// уже приняли новую форму, использование в спец. режиме особого значение - не допустимо.
		Если СпецРежимНалогообложения = 7 Тогда
			СпецРежимНалогообложения = 0;
		КонецЕсли;
	Иначе	
		// еще не приняли новую форму, для НН с НДС 7% нужно в спец. режиме указывать особое занчение (7)
		Отбор = Новый Структура("СтавкаНДС", Перечисления.СтавкиНДС.НДС7);
		Если НДСИсходящийСервер.ВДокументеЕстьСтавкаНДС7(ЭтотОбъект) Тогда
			СпецРежимНалогообложения = 7;
		Иначе	
			Если СпецРежимНалогообложения = 7 Тогда
				СпецРежимНалогообложения = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ Тогда
		ДокументУменьшаетНО = ТоварыПоДаннымПользователя.Итог("СуммаНДСРегл") < 0;
	Иначе
		ДокументУменьшаетНО = Товары.Итог("СуммаНДСРегл") < 0;
	КонецЕсли;
	Если ТипПричиныНевыдачиПокупателю = 0
		И ДокументУменьшаетНО Тогда
		РегистрируетсяВЕРННПокупателем = Истина;
	Иначе
		РегистрируетсяВЕРННПокупателем = Ложь;
	КонецЕсли;
	
	Если НЕ СтатусРегистрацииВЕРНН = Перечисления.СтатусыРегистрацииВЕРНННалоговыхДокументов.ЗарегистрированВЕРНН Тогда
		ДатаВключенияВЕдиныйРеестрНалоговыхНакладных = '0001-01-01';
	ИначеЕсли НачалоМесяца(Дата) = НачалоМесяца(ДатаВключенияВЕдиныйРеестрНалоговыхНакладных) Тогда
		ДатаВключенияВЕдиныйРеестрНалоговыхНакладных = Дата;
	Иначе	
		ДатаВключенияВЕдиныйРеестрНалоговыхНакладных = НачалоМесяца(ДатаВключенияВЕдиныйРеестрНалоговыхНакладных);		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ Тогда
		ИмяАктивнойТЧ = "ТоварыПоДаннымПользователя";
		// Для т.ч. Товары корректность заполнения гарантируется системой
	Иначе
		ИмяАктивнойТЧ = "Товары";
		// Т.ч. ТоварыПоДаннымПользователя будет очищена ПриЗаписи(...)
	КонецЕсли;
	ПрефиксРеквизитовНеАктивнойТЧ = ?(ИмяАктивнойТЧ = "Товары", "ТоварыПоДаннымПользователя", "Товары") + ".";
	Для каждого ИмяПроверяемогоРеквизита Из ПроверяемыеРеквизиты Цикл
		Если Лев(ИмяПроверяемогоРеквизита, СтрДлина(ПрефиксРеквизитовНеАктивнойТЧ)) = ПрефиксРеквизитовНеАктивнойТЧ Тогда
			МассивНепроверяемыхРеквизитов.Добавить(ИмяПроверяемогоРеквизита);
		КонецЕсли;
	КонецЦикла;
	ПараметрыПроверкиЗаполненияХарактеристик = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверкиЗаполненияХарактеристик.ИмяТЧ = ИмяАктивнойТЧ;
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверкиЗаполненияХарактеристик);

	Если ЗначениеЗаполнено(Организация) И Не НДСОбщегоНазначенияСервер.ОрганизацияКонтрагентПлательщикНДС(Организация, Дата) Тогда
		ТекстОшибки = НСтр("ru='Организация не является плательщиком НДС';uk='Організація не є платником ПДВ'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Организация",
			,
			Отказ
		);
	КонецЕсли;

	Если ЗначениеЗаполнено(НалоговаяНакладная)
	 // Для Продажи ниже обычной цены в НН Партнер и Контрагент используются только в качестве дополнительного отбора	
	 И НЕ (ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ПродажаНижеОбычнойЦены) Тогда	

		АналитикаП2 = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(ЭтотОбъект);
		АналитикаНН = РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(НалоговаяНакладная);
		
		Если НЕ АналитикаП2 = АналитикаНН Тогда
		
			ТекстОшибки = НСтр("ru='Не совпадает аналитика взаиморасчетов с корректируемой Налоговой накладной';uk='Не збігається аналітика взаєморозрахунків з коригованою Податковою накладною'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"НалоговаяНакладная",
				,
				Отказ
			);
		
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДокументУменьшаетНО Тогда
		Если НЕ СтатусРегистрацииВЕРНН = Перечисления.СтатусыРегистрацииВЕРНННалоговыхДокументов.ЗарегистрированВЕРНН Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДатаВключенияВЕдиныйРеестрНалоговыхНакладных");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Документ не зарегистрирован в ЕРНН и не указан период включения в Декларацию по НДС (реквизит ""Включить в Декларацию за:"")! Проводки сформированы частично.';uk='Документ не зареєстрований в ЄРПН і не зазначений період включення до Декларації з ПДВ (реквізит """"Включити до Декларації за:"""")! Проводки сформовані частково.'"),
				,
				"Объект.СтатусРегистрацииВЕРНН",
				,);
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВключенияВЕдиныйРеестрНалоговыхНакладных");
	КонецЕсли;

	Если Статус = Перечисления.СтатусыНалоговыхДокументов.Проверен Тогда
		Если НалоговаяНакладнаяНеЗарегистрированаВИБ Тогда
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладная");
		Иначе
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладнаяНомер");
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладнаяДата");
		КонецЕсли;
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладная");
		МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладнаяНомер");
		МассивНепроверяемыхРеквизитов.Добавить("НалоговаяНакладнаяДата");
	КонецЕсли;

	Если ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.УсловнаяПродажа
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.СводнаяУсловнаяПродажа
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ПродажаНижеОбычнойЦены
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ИтоговаяРозницаОблагаемыеОперации
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.ИтоговаяРозницаОсвобожденныеОперации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	КонецЕсли;

	Если '2014-12-01' > Дата  Тогда
		Если НДСИсходящийСервер.ВДокументеЕстьСтавкаНДС7ИДругиеСтавки(ЭтотОбъект) Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

	Если Не ВключаетсяВУточняющийРасчет Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОтгрузкиОплаты");
	КонецЕсли;
	
	Если НЕ (ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.УсловнаяПродажа) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыПоДаннымПользователя.НалоговоеНазначение"); 
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыПоДаннымПользователя.НалоговоеНазначениеПоФактуУсловнаяПродажа");
	КонецЕсли;
	
		МассивНепроверяемыхРеквизитов.Добавить("ТоварыПоДаннымПользователя.ОбъектЗаполненияСодержанияУсловнаяПродажа");

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.Приложение2КНалоговойНакладной.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	
	НДСИсходящийСервер.ОтразитьНДСНоменклатурныйСоставДляНалоговыхНакладных(ДополнительныеСвойства, Движения, Отказ);
	
	НДСИсходящийСервер.ОтразитьНДСРеестрВыданныхНалоговыхДокументов(ДополнительныеСвойства, Движения, Отказ);
	
	НДСИсходящийСервер.ОтразитьНДСУсловныеПродажи(ДополнительныеСвойства, Движения, Отказ);
	
	//
	//++ НЕ УТ
	ПроведениеСервер.ОтразитьДвижения(
    	ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСуммыКорректировокПропорциональногоНДС,
    	Движения.СуммыКорректировокПропорциональногоНДС,
    	Отказ
    );
	//-- НЕ УТ

	//++ НЕ УТ
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);



	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
		
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);



	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован             = Ложь;
	Статус                 = Перечисления.СтатусыНалоговыхДокументов.КПроверке;
	СтатусВыдачиПокупателю = Перечисления.СтатусыВыдачиПокупателюНалоговыхДокументов.НеВыданПокупателю;
	СтатусРегистрацииВЕРНН = Перечисления.СтатусыРегистрацииВЕРНННалоговыхДокументов.НеЗарегистрированВЕРНН;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Валюта = НДСОбщегоНазначенияСервер.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОбособленноеПодразделение = НДСИсходящийСервер.ОпределитьОбособленноеПодразделениеПоУмолчанию(
		Организация, 
		Договор
	);
	
	КтоВыписалНалоговуюНакладную = НДСИсходящийСервер.ОпределитьОтветственногоЗаВыпискуНалоговыхДокументов(
		Организация, 
		Договор
	);
	
	Если ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.РозницаКонрагентуОблагаемыеОперации
	 ИЛИ ВидОперации = Перечисления.ВидыОперацийНалоговыхДокументов.РозницаКонрагентуОсвобожденныеОперации Тогда
	 	Если Не ЗначениеЗаполнено(Партнер) Тогда
			Партнер = Справочники.Партнеры.РозничныйПокупатель;
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьСуммыРеглВТабличныхЧастях()
	ЗаполнитьСуммыРеглВТабличнойЧастиТовары(Товары);
	ЗаполнитьСуммыРеглВТабличнойЧастиТовары(ТоварыПоДаннымПользователя);
КонецПроцедуры


Процедура ЗаполнитьСуммыРеглВТабличнойЧастиТовары(ТабличнаяЧасть)	
	
	СтруктураКурсовВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Документы.Приложение2КНалоговойНакладной.ПолучитьДатуКурсаВалюты(ЭтотОбъект));
	
	ВалютаРегУчета = Константы.ВалютаРегламентированногоУчета.Получить(); 
				
	СуммаОстаток = 0;
	
	Для Каждого СтрокаТовары Из ТабличнаяЧасть Цикл	
		
		ПроцентНДС = НДСОбщегоНазначенияКлиентСервер.ПолучитьСтавкуНДСЧислом(СтрокаТовары.СтавкаНДС);
		
		СуммаСНДСГрн = НДСОбщегоНазначенияКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаТовары.СуммаСНДС,
					Валюта, ВалютаРегУчета,
					СтруктураКурсовВалюты.Курс, 1,
					СтруктураКурсовВалюты.Кратность, 1);
										
		СуммаНДСГрн  = НДСОбщегоНазначенияКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаТовары.СуммаНДС,
					Валюта, ВалютаРегУчета,
					СтруктураКурсовВалюты.Курс, 1,
					СтруктураКурсовВалюты.Кратность, 1);
					
		СтрокаТовары.СуммаНДСРегл = СуммаНДСГрн;
		
		СтрокаТовары.СуммаБезНДСРегл = СуммаСНДСГрн - СтрокаТовары.СуммаНДСРегл;
		
		СтрокаТовары.ЦенаРегл = НДСОбщегоНазначенияКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаТовары.Цена,
					Валюта, ВалютаРегУчета,
					СтруктураКурсовВалюты.Курс, 1,
					СтруктураКурсовВалюты.Кратность, 1); 
		
		СуммаОстаток = СуммаОстаток + (СуммаНДСГрн - СтрокаТовары.СуммаНДСРегл);
		
		Если СуммаОстаток >= 0.005 Тогда
			СтрокаТовары.СуммаНДСРегл    = СтрокаТовары.СуммаНДСРегл 	 + СуммаОстаток;
			СтрокаТовары.СуммаБезНДСРегл = СуммаСНДСГрн - СтрокаТовары.СуммаНДСРегл;
			СуммаОстаток = СуммаОстаток - 0.01;
		КонецЕсли;
		
		Если СуммаОстаток <  - 0.005 Тогда
			СтрокаТовары.СуммаНДСРегл = СтрокаТовары.СуммаНДСРегл 	 + СуммаОстаток;
			СтрокаТовары.СуммаБезНДСРегл = СуммаСНДСГрн - СтрокаТовары.СуммаНДСРегл;
			СуммаОстаток = СуммаОстаток + 0.01;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПослеАвтоформирования(ЭтоНовыйОбъект = Истина) Экспорт
	
	Если ЭтоНовыйОбъект Тогда
		
		Если ЗначениеЗаполнено(НалоговаяНакладная) Тогда
			ОбособленноеПодразделение = НалоговаяНакладная.ОбособленноеПодразделение;
		КонецЕсли;
		
		Если СтатусВыдачиПокупателю = Перечисления.СтатусыВыдачиПокупателюНалоговыхДокументов.ВыданПокупателю Тогда
			СтатусВыдачиПокупателю = Перечисления.СтатусыВыдачиПокупателюНалоговыхДокументов.ПодлежитПовторнойВыдаче;
		Иначе
			СтатусВыдачиПокупателю = Перечисления.СтатусыВыдачиПокупателюНалоговыхДокументов.НеВыданПокупателю;
		КонецЕсли;
		
		СтатусРегистрацииВЕРНН = Перечисления.СтатусыРегистрацииВЕРНННалоговыхДокументов.НеЗарегистрированВЕРНН;
		
		Если ЗначениеЗаполнено(НалоговаяНакладная) Тогда
			Если НЕ ЗначениеЗаполнено(ВидОперацииВозвратКорректировка) Тогда
				ВидОперацииВозвратКорректировка = Перечисления.ВидыОперацийПриложений2КНалоговойНакладной.Корректировка;
			КонецЕсли;
				
			Если ВидОперацииВозвратКорректировка = Перечисления.ВидыОперацийПриложений2КНалоговойНакладной.Корректировка
				ИЛИ ВидОперацииВозвратКорректировка = Перечисления.ВидыОперацийПриложений2КНалоговойНакладной.КорректировкаВозврата Тогда
	    		ВидОперации = НалоговаяНакладная.ВидОперации;
			КонецЕсли;
			
			СпецРежимНалогообложения = НалоговаяНакладная.СпецРежимНалогообложения;
			ТипПричиныНевыдачиПокупателю = НалоговаяНакладная.ТипПричиныНевыдачиПокупателю;
		Иначе
			ВалютаРегУчета = Константы.ВалютаРегламентированногоУчета.Получить();
			Документы.Приложение2КНалоговойНакладной.УстановитьТипПричиныНевыдачиПокупателюПоУмолчанию(ЭтотОбъект);
		КонецЕсли;
		
		Если ТипПричиныНевыдачиПокупателю = 7 Тогда
			ДатаОтгрузкиОплаты = Дата;
		КонецЕсли;
	КонецЕсли;
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КоличествоСтрок = Товары.Количество();
	
	Для Ин=1 по КоличествоСтрок Цикл
		
		СтрокаТовары = Товары[КоличествоСтрок - Ин];
		
		Если СтрокаТовары.КоличествоУпаковок = 0 И СтрокаТовары.СуммаСНДС = 0 Тогда
			Товары.Удалить(СтрокаТовары);
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТовары.ДокументПоставки) И СтрокаТовары.НеПересчитыватьСумму Тогда
			СтрокаТовары.НеПересчитыватьСумму = Ложь;
		КонецЕсли; 
					
		СтрокаТовары.ЭтоКорректировкаКоличества = НЕ Переоценка;
		
		ПроцентНДС = НДСОбщегоНазначенияКлиентСервер.ПолучитьСтавкуНДСЧислом(СтрокаТовары.СтавкаНДС);
		СтрокаТовары.СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(СтрокаТовары.СуммаСНДС, ПроцентНДС, Истина);
		СтрокаТовары.СуммаБезНДС = СтрокаТовары.СуммаСНДС - СтрокаТовары.СуммаНДС;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		НДСИсходящийСервер.ОбработатьСтрокуТЧ(СтрокаТовары, СтруктураДействий, КэшированныеЗначения);

		Если НЕ ЗначениеЗаполнено(СтрокаТовары.СтатьяДекларацииНДСНалоговыеОбязательства) Тогда
			Документы.Приложение2КНалоговойНакладной.ЗаполнитьСтатьюДекларацииНДСНалоговыеОбязательства(ВидОперации, СтрокаТовары.СтатьяДекларацииНДСНалоговыеОбязательства)
		КонецЕсли;
		
		НДСИсходящийСервер.ЗаполнитьНоменклатуруГТДПоУмолчанию(СтрокаТовары);
		
	КонецЦикла;	
	Если  ЭтоНовыйОбъект Тогда
		

		
		ОбособленноеПодразделение = НДСИсходящийСервер.ОпределитьОбособленноеПодразделениеПоУмолчанию(
			Организация, 
			Договор
		);
		
		КтоВыписалНалоговуюНакладную = НДСИсходящийСервер.ОпределитьОтветственногоЗаВыпискуНалоговыхДокументов(
			Организация, 
			Договор
		);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтатусАвтокорректировки) Тогда
		СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТекущийДокумент;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоАвтоформирование", Истина);
	
	Если ЗначениеЗаполнено(ДатаОтгрузкиОплаты) И (НачалоМесяца(ДатаОтгрузкиОплаты) <> НачалоМесяца(Дата)) Тогда
		ВключаетсяВУточняющийРасчет = Истина;
	КонецЕсли;
	
	НалоговаяНакладнаяНеЗарегистрированаВИБ = НЕ ЗначениеЗаполнено(НалоговаяНакладная);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПослеФормированияПоУсловнымПродажам() Экспорт
	
	Валюта = НДСОбщегоНазначенияСервер.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	ОбособленноеПодразделение = НДСИсходящийСервер.ОпределитьОбособленноеПодразделениеПоУмолчанию(
		Организация, 
		Договор
	);
	
	КтоВыписалНалоговуюНакладную = НДСИсходящийСервер.ОпределитьОтветственногоЗаВыпискуНалоговыхДокументов(
		Организация, 
		Договор
	);
	
	Если Не ЗначениеЗаполнено(ТипПричиныНевыдачиПокупателю) Тогда
		Документы.Приложение2КНалоговойНакладной.УстановитьТипПричиныНевыдачиПокупателюПоУмолчанию(ЭтотОбъект);	
	КонецЕсли;	

	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	КоличествоСтрок = ТоварыПоДаннымПользователя.Количество();
	
	Для Ин=1 по КоличествоСтрок Цикл
		
		СтрокаТовары = ТоварыПоДаннымПользователя[КоличествоСтрок - Ин];
		
		СтрокаТовары.ЭтоКорректировкаКоличества = НЕ Переоценка;
		
		СтрокаТовары.СуммаСНДС = СтрокаТовары.СуммаБезНДС + СтрокаТовары.СуммаНДС;
		
		СтрокаТовары.Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(СтрокаТовары.Номенклатура);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
		СтруктураДействий.Вставить("ПересчитатьЦенуСкидкуПоСуммеВПродажах", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаЦеныСкидкиВПродажахВТЧ(ЭтотОбъект, Истина));
		НДСИсходящийСервер.ОбработатьСтрокуТЧ(СтрокаТовары, СтруктураДействий, КэшированныеЗначения);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТовары.СтатьяДекларацииНДСНалоговыеОбязательства) Тогда
			Документы.Приложение2КНалоговойНакладной.ЗаполнитьСтатьюДекларацииНДСНалоговыеОбязательства(ВидОперации, СтрокаТовары.СтатьяДекларацииНДСНалоговыеОбязательства)
		КонецЕсли;
		
		НДСИсходящийСервер.ЗаполнитьНоменклатуруГТДПоУмолчанию(СтрокаТовары, Ложь);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТовары.Номенклатура) И ЗначениеЗаполнено(СтрокаТовары.ОбъектЗаполненияСодержанияУсловнаяПродажа) Тогда
			Документы.Приложение2КНалоговойНакладной.ЗаполнитьСодержаниеДляУсловнойПродажи(СтрокаТовары.ОбъектЗаполненияСодержанияУсловнаяПродажа, СтрокаТовары.Содержание);
		КонецЕсли;
		
	КонецЦикла;
	
	
	Если НЕ ЗначениеЗаполнено(СтатусАвтокорректировки) Тогда
		СтатусАвтокорректировки = Перечисления.СтатусыАвтокорректировкиНалоговыхДокументов.ИсправлятьТехническуюТЧ;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли

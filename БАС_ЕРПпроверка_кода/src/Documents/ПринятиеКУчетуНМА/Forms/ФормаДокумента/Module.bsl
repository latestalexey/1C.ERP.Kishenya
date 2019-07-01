
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Объект.НематериальныйАктив);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Возврат;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы


 
&НаКлиенте
Процедура НематериальныйАктивПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НематериальныйАктивПриИзмененииНаСервере(Результат = КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииНаСервере(ЗаполнитьСчетаУчета=Ложь)
	
	ОбновитьДоступностьЭлементовФормы("НематериальныйАктив");
	Если ЗаполнитьСчетаУчета Тогда
		ЗаполнитьЗначенияСвойств(Объект, СчетаУчетаНематериальныйАктивовПоУмолчанию(ВидОбъектаУчета));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюБУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НачислятьАмортизациюБУ");
	Объект.НачислятьАмортизациюНУ = Объект.НачислятьАмортизациюБУ;
	ОбновитьДоступностьЭлементовФормы("НачислятьАмортизациюНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюНУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НачислятьАмортизациюНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	СпособНачисленияАмортизацииБУПриИзмененииНаСервере(Объект.СпособНачисленияАмортизацииНУ);

	ОбновитьДоступностьЭлементовФормы("СпособНачисленияАмортизацииБУ");
		
КонецПроцедуры

&НаСервере
Процедура СпособНачисленияАмортизацииБУПриИзмененииНаСервере(СпособНачисленияАмортизацииНУ)
	
		СпособНачисленияАмортизацииНУ = 
			?(Объект.СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции,
				Объект.СпособНачисленияАмортизацииБУ,Перечисления.СпособыНачисленияАмортизацииНМА.Линейный);	
		
КонецПроцедуры


&НаКлиенте
Процедура СрокИспользованияБУПриИзменении(Элемент)
	
	Если Объект.СрокИспользованияНУ = 0
		Или СрокИспользованияБУ = Объект.СрокИспользованияНУ Тогда
		
		Объект.СрокИспользованияНУ = Объект.СрокИспользованияБУ;
		СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияНУ);
		
	КонецЕсли;
	
	СрокИспользованияБУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияБУ);
	
	СрокИспользованияБУ = Объект.СрокИспользованияБУ;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУПриИзменении(Элемент)
	
	СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияНУ);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры



 
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("Организация");
	
КонецПроцедуры


#КонецОбласти





#Область ОбработчикиКоманд
#Область СтандартныеПодсистемы

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	СрокИспользованияБУ = Объект.СрокИспользованияБУ;
	
	ОбновитьДоступностьЭлементовФормы();
	
	
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	Если ОбновитьВсе Тогда
		
		СпособыНачисленияАмортизацииБУ = Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора;
		СпособыНачисленияАмортизацииБУ.Очистить();
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Линейный);
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		
		СпособыНачисленияАмортизацииНУ = Элементы.СпособНачисленияАмортизацииНУ.СписокВыбора;
		СпособыНачисленияАмортизацииНУ.Очистить();
		СпособыНачисленияАмортизацииНУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Линейный);
		СпособыНачисленияАмортизацииНУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		СпособыНачисленияАмортизацииНУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УскоренногоУменьшенияОстатка);
		СпособыНачисленияАмортизацииНУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Кумулятивный);
		
			
			Элементы.СчетНачисленияАмортизации.Видимость = Истина;
			
			
			Элементы.СчетУчета.Заголовок = НСтр("ru='Счет учета актива';uk='Рахунок обліку активу'");
			Элементы.НематериальныйАктив.Заголовок = НСтр("ru='Нематериальный актив';uk='Нематеріальний актив'");
			Элементы.НачислятьАмортизациюБУ.Заголовок = НСтр("ru='Начисление амортизации';uk='Нарахування амортизації'");
			Элементы.СрокИспользованияБУ.Заголовок= НСтр("ru='Срок использования (месяцев)';uk='Термін використання (місяців)'");
			Элементы.СпособНачисленияАмортизацииБУ.Заголовок= НСтр("ru='Способ начисления амортизации';uk='Спосіб нарахування амортизації'");
			Элементы.СрокИспользованияНУ.Заголовок= НСтр("ru='Срок использования (месяцев)';uk='Термін використання (місяців)'");
			
			Реквизиты.Вставить("НачислятьАмортизациюБУ");
			Реквизиты.Вставить("НачислятьАмортизациюНУ");
			

		Элементы.ОбъемНаработкиБУ.Видимость = (
			Реквизиты.Свойство("НачислятьАмортизациюБУ")
			И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);

	КонецЕсли;
	
	Если Реквизиты.Свойство("НачислятьАмортизациюБУ") Тогда
		Элементы.ГруппаСрокИспользованияБУ.Видимость = Объект.НачислятьАмортизациюБУ;
		Реквизиты.Вставить("СпособНачисленияАмортизацииБУ");
		Элементы.СпособНачисленияАмортизацииБУ.Видимость = Объект.НачислятьАмортизациюБУ;
		Элементы.ГруппаОтражениеРасходов.Видимость		 = Объект.НачислятьАмортизациюБУ;
		Элементы.ЛиквидационнаяСтоимостьБУ.Видимость     = Объект.НачислятьАмортизациюБУ;
		Элементы.НачислятьАмортизациюНУ.Видимость        = Объект.НачислятьАмортизациюБУ;
	КонецЕсли;
	
	Если Реквизиты.Свойство("НачислятьАмортизациюНУ") Тогда
		
		Элементы.ГруппаСрокИспользованияНУ.Видимость	=	НЕ(Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность
															ИЛИ (НЕ Объект.НачислятьАмортизациюНУ));
		Элементы.СпособНачисленияАмортизацииНУ.Видимость=	НЕ (Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность
															ИЛИ (НЕ Объект.НачислятьАмортизациюНУ));
	КонецЕсли;
	
	Если Реквизиты.Свойство("СпособНачисленияАмортизацииБУ") Тогда
		
		Элементы.СрокИспользованияБУ.АвтоОтметкаНезаполненного = (
			Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			Или Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		
		Если Не Элементы.СрокИспользованияБУ.АвтоОтметкаНезаполненного Тогда
			Элементы.СрокИспользованияБУ.ОтметкаНезаполненного = Ложь;
		КонецЕсли;
		
		Элементы.ОбъемНаработкиБУ.Видимость = (
			Объект.НачислятьАмортизациюБУ
			И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
			
		Элементы.СрокИспользованияБУ.Видимость = (
			Объект.НачислятьАмортизациюБУ
			И Объект.СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);

		Элементы.РасшифровкаСрокаПолезногоИспользованияБУ.Видимость = (
			Объект.НачислятьАмортизациюБУ
			И Объект.СпособНачисленияАмортизацииБУ <> Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		 
	КонецЕсли;
	
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СрокИспользованияБУ") Тогда
		СрокИспользованияБУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияБУ);
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СрокИспользованияНУ") Тогда
		СрокИспользованияНУРасшифровка = БухгалтерскийУчетКлиентСерверПереопределяемый.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияНУ);
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НДС") Тогда
		
		
	КонецЕсли;
	
	
	Если ОбновитьВсе Или Реквизиты.Свойство("Организация") Тогда
		
		
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НалоговаяГруппаОС") Тогда
		
		НалоговаяГруппаОС = Элементы.НалоговаяГруппаОС.СписокВыбора;
		НалоговаяГруппаОС.Очистить();
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа1);
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа2);
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа3);
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа4);
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа5);
		НалоговаяГруппаОС.Добавить(Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа6);
		
	КонецЕсли; 
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НалоговоеНазначение") Тогда
		Элементы.ГруппаНУ.Видимость = НЕ (Объект.НалоговоеНазначение = Справочники.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность);
	КонецЕсли;		
	 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СчетаУчетаНематериальныйАктивовПоУмолчанию(ВидОбъектаУчета)
	
	СчетаПоУмолчанию = Новый Структура("СчетУчета, СчетНачисленияАмортизации");
	СчетаПоУмолчанию.СчетНачисленияАмортизации = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.НакопленнаяАмортизацияНематериальныхАктивов");

	Возврат СчетаПоУмолчанию;
	
КонецФункции


&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры

 
&НаКлиенте
Процедура НалоговаяГруппаОСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбновитьДоступностьЭлементовФормы("НалоговаяГруппаОС");
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	СчетУчетаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СчетУчетаПриИзмененииНаСервере()
	
	СчетУчета = Объект.СчетУчета;
	
	Если СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаИспользованиеПриродныхРесурсов Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа1;
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаИспользованиеИмущества Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа2;
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаЗнакиДляТоваровИУслуг Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа3;
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаОбъектыПромышленнойСобственности Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа4;
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.АвторскиеИСмежныеСНимиПрава Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа5;
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ДругиеНематериальныеАктивы Тогда
		Объект.НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа6;
	КонецЕсли; 


КонецПроцедуры

&НаКлиенте
Процедура НалоговаяГруппаОСПриИзменении(Элемент)
	НалоговаяГруппаОСПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура НалоговаяГруппаОСПриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.СчетУчета) Тогда
		
		НалоговаяГруппаОС = Объект.НалоговаяГруппаОС;
		
		Если НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа1 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаИспользованиеПриродныхРесурсов;
		ИначеЕсли НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа2 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаИспользованиеИмущества;
		ИначеЕсли НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа3 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаЗнакиДляТоваровИУслуг;
		ИначеЕсли НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа4 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.ПраваНаОбъектыПромышленнойСобственности;
		ИначеЕсли НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа5 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.АвторскиеИСмежныеСНимиПрава;
		ИначеЕсли НалоговаяГруппаОС = Справочники.НалоговыеГруппыОсновныхСредств.НМАГруппа6 Тогда
			Объект.СчетУчета = ПланыСчетов.Хозрасчетный.ДругиеНематериальныеАктивы;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговоеНазначениеПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("НалоговоеНазначение");
КонецПроцедуры

#КонецОбласти

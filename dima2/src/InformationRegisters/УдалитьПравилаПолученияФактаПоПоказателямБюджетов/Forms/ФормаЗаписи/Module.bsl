
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи) Тогда
		
		Если Параметры.ЗначениеКопирования.Пустой() Тогда
			ИнициализироватьКомпоновщикСервер(Неопределено);
		Иначе
			ЗаписьКопирования = РегистрыСведений.ПравилаПолученияФактаПоПоказателямБюджетов.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(ЗаписьКопирования, Параметры.ЗначениеКопирования);
			ЗаписьКопирования.Прочитать();
			ИнициализироватьКомпоновщикСервер(ЗаписьКопирования.КомпоновщикНастроек.Получить());
		КонецЕсли;
	
	КонецЕсли;
	
	ЗаполнитьВидыАналитики();
	ЗаполнитьНастройкиЗаполненияАналитики();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМеждународныйФинансовыйУчет") Тогда
		Разделы = Элементы.РазделИсточникаДанных.СписокВыбора;
		РазделМеждународныйУчет = Разделы.НайтиПоЗначению(Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
		Если РазделМеждународныйУчет <> Неопределено Тогда
			Разделы.Удалить(РазделМеждународныйУчет);
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеПоказателяБюджетов = Строка(Запись.ПоказательБюджетов);
	
	УстановитьУсловноеОформление();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СохраненныйКомпоновщикНастроек = ТекущийОбъект.КомпоновщикНастроек.Получить();
	ИнициализироватьКомпоновщикСервер(СохраненныйКомпоновщикНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.КомпоновщикНастроек = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
	ТекущийОбъект.ПредставлениеОтбора = Строка(КомпоновщикНастроек.Настройки.Отбор);
	Если ТекущийОбъект.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
		ТекущийОбъект.СхемаИсточникаДанных = Новый ХранилищеЗначения(СхемаКомпоновкиДанных);
	КонецЕсли;
	
	БюджетированиеСервер.ПоместитьНастройкиЗаполненияАналитикиВПравило(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	БюджетированиеСервер.ОбработкаПроверкиНастроекЗаполненияАналитики(НастройкиЗаполненияАналитики, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИсточникДанныхПриИзменении(Элемент)
	
	ПриИзмененииИсточникаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РазделИсточникаДанныхПриИзменениии(Элемент)
	
	ПриИзмененииРазделаИсточникаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательБюджетовПриИзменении(Элемент)
	
	ПриИзмененииПоказателяБюджетовСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидАналитики",               ТекущиеДанные.ВидАналитики);
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных", АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("РазделИсточникаДанных",      Запись.РазделИсточникаДанных);
	ПараметрыФормы.Вставить("ТекущееВыражение",           ТекущиеДанные.ВыражениеЗаполненияАналитики);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПоляЗаполненияАналитики", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	ТекущиеДанные.ВыражениеЗаполненияАналитики = ВыбранноеЗначение;
	
	ВыражениеЗаполненияАналитикиОбработкаВыбораСервер(ТекущиеДанные.ПолучитьИдентификатор());
	Модифицированность = Истина;
	Элементы.НастройкиЗаполненияАналитики.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиВыражениеЗаполненияАналитикиОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗаполненияАналитикиПриАктивизацииСтроки(Элемент)
	
	ПараметрыВыбора = Новый Массив;
	
	ТекущиеДанные = Элементы.НастройкиЗаполненияАналитики.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ДополнительноеСвойство) Тогда
		НовыйПараметрВыбора = Новый ПараметрВыбора("Отбор.Владелец", ТекущиеДанные.ДополнительноеСвойство);
	КонецЕсли;
	
	Элементы.НастройкиЗаполненияАналитикиЗначениеАналитики.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСхемуПолученияДанных(Команда)
	
	
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru='Настройки схемы получения произвольных данных';uk='Настройки схеми отримання довільних даних'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресСхемыКомпоновкиДанных",            АдресСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("Заголовок",                             ЗаголовокФормыНастройкиСхемыКомпоновкиДанных);
	ПараметрыФормы.Вставить("УникальныйИдентификатор",               УникальныйИдентификатор);
	ПараметрыФормы.Вставить("НеНастраиватьУсловноеОформление",       Истина);
	ПараметрыФормы.Вставить("НеНастраиватьПорядок",                  Истина);
	ПараметрыФормы.Вставить("НеНастраиватьОтбор",                    Истина);
	ПараметрыФормы.Вставить("НеНастраиватьВыбор",                    Истина);
	ПараметрыФормы.Вставить("НеПомещатьНастройкиВСхемуКомпоновкиДанных", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзмененитьСхемуКомпоновкиДанных", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьРежимРасширеннойНастройкиЗаполненияАналитики(Команда)
	
	ОтключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРежимРасширеннойНастройкиЗаполненияАналитик(Команда)
	
	ВключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНастройкиАналитикиПоИсточникуДанных(Команда)
	
	ЗаполнитьНастройкиАналитикиПоИсточникуДанныхСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	БюджетированиеСервер.УстановитьУсловноеНастроекЗаполненияАналитики(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыАналитики()
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВидАналитики1");
	Реквизиты.Вставить("ВидАналитики2");
	Реквизиты.Вставить("ВидАналитики3");
	Реквизиты.Вставить("ВидАналитики4");
	Реквизиты.Вставить("ВидАналитики5");
	Реквизиты.Вставить("ВидАналитики6");
	ВидыАналитики = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.ПоказательБюджетов, Реквизиты);
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ВидыАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененитьСхемуКомпоновкиДанных(Результат, Параметры) Экспорт
	
	Модифицированность = Истина;
	ИзмененаСхемаКомпоновкиДанныхСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПоказателяБюджетовСервер()
	
	РазделПроизвольныеДанные = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные;
	СтрокаПоказательБюджетов = Строка(Запись.ПоказательБюджетов);
	Если Запись.РазделИсточникаДанных = РазделПроизвольныеДанные 
		И (Запись.ИсточникДанных = ПредставлениеПоказателяБюджетов Или Запись.ИсточникДанных = "") Тогда
		Запись.ИсточникДанных = СтрокаПоказательБюджетов;
	КонецЕсли;
	ПредставлениеПоказателяБюджетов = СтрокаПоказательБюджетов;
	
	ЗаполнитьВидыАналитики();
	ЗаполнитьНастройкиЗаполненияАналитики();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИсточникаСервер()
	
	НастроитьЭлементыФормы();
	
	Если Запись.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные 
		И Запись.ИсточникДанных = "" Тогда
		Запись.ИсточникДанных = ПредставлениеПоказателяБюджетов;
	КонецЕсли;
	
	ПолучитьСхемуКомпоновкиДанных();
	ИнициализироватьКомпоновщикСервер(КомпоновщикНастроек.ПолучитьНастройки());
	БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Запись, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРазделаИсточникаСервер()
	
	Раздел = Запись.РазделИсточникаДанных; 
	
	ПравилоПоРеглУчету = (Раздел = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет);
	ПравилоПоМеждународномуУчету = (Раздел = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
	
	Если Не ПравилоПоРеглУчету И Не ПравилоПоМеждународномуУчету Тогда 
		Запись.ТипИтога = Неопределено;
	КонецЕсли;
	
	ПриИзмененииИсточникаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкаКомпоновки)
	
	Если Не ЗначениеЗаполнено(Запись.РазделИсточникаДанных) Или Не ЗначениеЗаполнено(Запись.ИсточникДанных) Тогда
		КомпоновщикНастроек.Инициализировать(Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресСхемыКомпоновкиДанных) Тогда
		ПолучитьСхемуКомпоновкиДанных();
	КонецЕсли;
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ПравилоПоОперативномуУчету = 
		(Запись.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ОперативныйУчет);
	ПравилоПоРеглУчету = 
		(Запись.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.РегламентированныйУчет);
	ПравилоПоМеждународномуУчету = 
		(Запись.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.МеждународныйУчет);
	ПравилоПоПроизвольнымДанным = 
		(Запись.РазделИсточникаДанных = Перечисления.РазделыИсточниковДанныхБюджетирования.ПроизвольныеДанные);
	
	Элементы.ТипИтога.Видимость = ПравилоПоРеглУчету Или ПравилоПоМеждународномуУчету;
	
	ОписаниеТиповИсточника = Новый ОписаниеТипов(Неопределено);
	ЗаголовокИсточника = НСтр("ru='Источник данных';uk='Джерело даних'");
	Если ПравилоПоОперативномуУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов");
		ЗаголовокИсточника = НСтр("ru='Статья активов/пассивов';uk='Стаття активів/пасивів'");
	ИначеЕсли ПравилоПоРеглУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный");
		ЗаголовокИсточника = НСтр("ru='Счет учета';uk='Рахунок'");
	ИначеЕсли ПравилоПоМеждународномуУчету Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("ПланСчетовСсылка.Международный");
		ЗаголовокИсточника = НСтр("ru='Счет учета';uk='Рахунок'");
	ИначеЕсли ПравилоПоПроизвольнымДанным Тогда
		ОписаниеТиповИсточника = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(200));
		Если ТипЗнч(Запись.ИсточникДанных) <> Тип("Строка") Тогда
			Запись.ИсточникДанных = Строка(Запись.ПоказательБюджетов);
		КонецЕсли;
	КонецЕсли;
	
	Запись.ИсточникДанных = ОписаниеТиповИсточника.ПривестиЗначение(Запись.ИсточникДанных);
	Элементы.ИсточникДанных.Заголовок = ЗаголовокИсточника;
	Элементы.ИсточникДанных.Видимость = ПравилоПоОперативномуУчету Или ПравилоПоРеглУчету Или ПравилоПоМеждународномуУчету;
	Элементы.ОписаниеПроизвольногоИсточникаДанных.Видимость = ПравилоПоПроизвольнымДанным;
	
	Элементы.НастроитьСхемуПолученияДанных.Видимость = ПравилоПоПроизвольнымДанным;
	
	Элементы.ВключитьРежимРасширеннойНастройкиЗаполненияАналитики.Видимость = Не Запись.РасширеныйРежимНастройкиЗаполненияАналитики;
	Элементы.ГруппаНастройкаЗаполненияАналитикиПояснение.Видимость = Не Запись.РасширеныйРежимНастройкиЗаполненияАналитики;
	
	Элементы.ОтключитьРежимРасширеннойНастройкиЗаполненияАналитики.Видимость = Запись.РасширеныйРежимНастройкиЗаполненияАналитики;
	Элементы.НастройкиЗаполненияАналитики.Видимость = Запись.РасширеныйРежимНастройкиЗаполненияАналитики;
	
КонецПроцедуры

&НаСервере
Процедура ИзмененаСхемаКомпоновкиДанныхСервер()
	
	Модифицированность = Истина;
	ИнициализироватьКомпоновщикСервер(КомпоновщикНастроек.ПолучитьНастройки());
	БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Запись, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСхемуКомпоновкиДанных()
	
	МенеджерЗаписи = ДанныеФормыВЗначение(Запись, Тип("РегистрСведенийМенеджерЗаписи.ПравилаПолученияФактаПоПоказателямБюджетов"));
	СхемаКомпоновкиДанных = 
		РегистрыСведений.ПравилаПолученияФактаПоПоказателямБюджетов.СхемаПолученияДанных(МенеджерЗаписи);
	БюджетированиеСервер.УстановитьСвойстваПолейДляНастройкиПравила(СхемаКомпоновкиДанных, Запись); 
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиЗаполненияАналитики()
	
	ВидыАналитик = Новый Структура;
	Для НомерАналитики = 1 По 6 Цикл
		ВидыАналитик.Вставить("ВидАналитики" + НомерАналитики, ЭтаФорма["ВидАналитики" + НомерАналитики]);
	КонецЦикла;
	БюджетированиеСервер.ЗаполнитьНастройкиЗаполненияАналитикиПоПравилу(ЭтаФорма, Запись, ВидыАналитик);
	БюджетированиеСервер.ПроверитьДоступностьПолейЗаполненияАналитики(ЭтаФорма, Запись);
	
КонецПроцедуры

&НаСервере
Процедура ВключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер()
	
	Запись.РасширеныйРежимНастройкиЗаполненияАналитики = Истина;
	ЗаполнитьНастройкиЗаполненияАналитики();
	БюджетированиеСервер.УстановитьНастройкиЗаполненияАналитикиАвтоматически(ЭтаФорма);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьРежимРасширеннойНастройкиЗаполненияАналитикиСервер()
	
	Запись.РасширеныйРежимНастройкиЗаполненияАналитики = Ложь;
	ЗаполнитьНастройкиЗаполненияАналитики();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиАналитикиПоИсточникуДанныхСервер()
	
	БюджетированиеСервер.УстановитьНастройкиЗаполненияАналитикиАвтоматически(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыражениеЗаполненияАналитикиОбработкаВыбораСервер(ИдентификаторСтроки) 
	
	БюджетированиеСервер.ПроверитьВыражениеЗаполненияАналитикиПослеВыбора(ЭтаФорма, ИдентификаторСтроки);
	
КонецПроцедуры

#КонецОбласти
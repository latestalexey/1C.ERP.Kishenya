
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ответственный = Пользователи.АвторизованныйПользователь();
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
	ОтветственныйИсх = Ответственный;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
	СтатусНераспакованногоПакета = Перечисления.СтатусыПакетовЭД.КРаспаковке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНераспакованногоПакета);
	
	СтатусНеотправленногоПакета = Перечисления.СтатусыПакетовЭД.ПодготовленКОтправке;
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеотправленногоПакета);
	
	АктуальныеВидыЭД = ОбменСКонтрагентамиПовтИсп.ПолучитьАктуальныеВидыЭД();
	
	МассивИсключенияВходящихЭД = Новый Массив();

	Элементы.ВидЭД.СписокВыбора.ЗагрузитьЗначения(АктуальныеВидыЭД);
	
	МассивИсключенияИсходящихЭД = Новый Массив();
	МассивИсключенияИсходящихЭД.Добавить(Перечисления.ВидыЭД.Подтверждение);
	
	ВидыЭДИсходящие = ОбщегоНазначенияКлиентСервер.СократитьМассив(АктуальныеВидыЭД, МассивИсключенияИсходящихЭД);
	Элементы.ВидЭДИсх.СписокВыбора.ЗагрузитьЗначения(ВидыЭДИсходящие);
	
	Элементы.Пакеты.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
	УстановитьПараметрыСписка("Список","ОтображатьВсеДокументы", ОтображатьВсеДокументы);
	УстановитьПараметрыСписка("СписокИсх","ОтображатьВсеДокументыИсх", ОтображатьВсеДокументыИсх);
	
	Элементы.ОтображатьВсеДокументы.Пометка = ОтображатьВсеДокументы;
	Элементы.ОтображатьВсеДокументыИсх.Пометка = ОтображатьВсеДокументыИсх;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "ВидЭД",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, Список, "СтатусЭД", Настройки);
	
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "ВидЭДИсх",    Настройки);
	ОтборПоЭлементуПриЗагрузкеИзНастроек(ЭтотОбъект, СписокИсх, "СтатусЭДИсх", Настройки);
	
	ПараметрОтображатьВсеДокументы = Настройки.Получить("ОтображатьВсеДокументы");
	Если Не ПараметрОтображатьВсеДокументы = Неопределено Тогда
		ОтображатьВсеДокументы = ПараметрОтображатьВсеДокументы;
		УстановитьПараметрыСписка("Список","ОтображатьВсеДокументы", ОтображатьВсеДокументы);
		Элементы.ОтображатьВсеДокументы.Пометка = ОтображатьВсеДокументы;
	КонецЕсли;
	
	ПараметрОтображатьВсеДокументыИсх = Настройки.Получить("ОтображатьВсеДокументыИсх");
	Если Не ПараметрОтображатьВсеДокументыИсх = Неопределено Тогда
		ОтображатьВсеДокументыИсх = ПараметрОтображатьВсеДокументыИсх;
		УстановитьПараметрыСписка("СписокИсх","ОтображатьВсеДокументыИсх", ОтображатьВсеДокументыИсх);
		Элементы.ОтображатьВсеДокументыИсх.Пометка = ОтображатьВсеДокументыИсх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		
		Элементы.Список.Обновить();
		Элементы.СписокИсх.Обновить();
		Элементы.НераспакованныеПакеты.Обновить();
		Элементы.НеотправленныеПакеты.Обновить();
		Элементы.ВсеПакеты.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "ВидЭД", ВидЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		НоваяСтруктура = Неопределено;
		Если ЭтоПроизвольныйДокумент(ВыбраннаяСтрока, НоваяСтруктура) Тогда
			ОткрытьФорму("Документ.ПроизвольныйЭД.Форма.ФормаДокумента", НоваяСтруктура);
			Возврат;
		КонецЕсли;
		
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "Ответственный", Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(Список, "СтатусЭД", СтатусЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНераспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Контрагент", КонтрагентНераспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНераспакованногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НераспакованныеПакеты, "Статус", СтатусНераспакованногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНеотправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Контрагент", КонтрагентНеотправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусНеотправленногоПакетаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(НеотправленныеПакеты, "Статус", СтатусНеотправленногоПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "Ответственный", ОтветственныйИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "ВидЭДИсх", ВидЭДИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусЭДИсхПриИзменении(Элемент)
	
	УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокИсх, "СтатусЭДИсх", СтатусЭДИсх);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтветственного(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппПользователей", Ложь);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",      Истина);
	ПараметрыФормы.Вставить("РежимВыбора",             Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборОтветственного", ЭтотОбъект);
	НовыйОтветственный = ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтотОбъект,
		УникальныйИдентификатор, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеЭДВх(Команда)
	
	СравнитьДанныеЭД(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеЭДИсх(Команда)
	
	СравнитьДанныеЭД(Элементы.СписокИсх);
	
КонецПроцедуры

&НаКлиенте
Процедура Распаковать(Команда)
	
	// Распаковываем только выделенные строки
	ОбменСКонтрагентамиСлужебныйКлиент.РаспаковатьПакетыЭДНаКлиенте(Элементы.НераспакованныеПакеты.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	// Отправить только выделенные строки
	МассивЭД = Элементы.НеотправленныеПакеты.ВыделенныеСтроки; 
	
	ОбработкаОповещения = Новый ОписаниеОповещения("КомандаОтправитьОповещение", ЭтотОбъект);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОтправитьМассивПакетовЭД(МассивЭД, ОбработкаОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправитьОповещение(КолОтправленныхПакетов, ДополнительныеПараметры) Экспорт
	
	ЗаголовокОповещения = НСтр("ru='Обмен электронными документами';uk='Обмін електронними документами'");
	ТекстОповещения     = НСтр("ru='Отправленных пакетов нет';uk='Відправлених пакетів немає'");
	
	Если ЗначениеЗаполнено(КолОтправленныхПакетов) Тогда
	
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Отправлено пакетов: (%1)';uk='Відправлено пакетів: (%1)'"), КолОтправленныхПакетов);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ЗаголовокОповещения, , ТекстОповещения);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКРаспаковке(Команда)
	
	ТаблицаПакетов = "НераспакованныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.КРаспаковке"), Количество);
	
	ТекстОповещения = НСтр("ru='Изменен статус пакетов на ""К распаковке""';uk='Змінено статус пакетів на ""До розпакування""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	
	ПоказатьОповещениеПользователя(НСтр("ru='Обмен электронными документами';uk='Обмін електронними документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтменен(Команда)
	
	Если Команда.Имя = "УстановитьСтатусОтмененНераспакованныеПакеты" Тогда
		ТаблицаПакетов = "НераспакованныеПакеты";
	Иначе
		ТаблицаПакетов = "НеотправленныеПакеты";
	КонецЕсли;
	
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.Отменен"), Количество);
	ТекстОповещения = НСтр("ru='Изменен статус пакетов на ""Отменен""';uk='Змінено статус пакетів на ""Скасовано""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru='Обмен электронными документами';uk='Обмін електронними документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусПодготовленКОтправке(Команда)
	
	ТаблицаПакетов = "НеотправленныеПакеты";
	Количество = 0;
	УстановитьСтатусПакетов(ТаблицаПакетов, ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.ПодготовленКОтправке"), Количество);
	ТекстОповещения = НСтр("ru='Изменен статус пакетов на ""Подготовлен к отправке""';uk='Змінено статус пакетів на ""Підготовлений до відправки""'") + ": (%1)";
	ТекстОповещения = СтрЗаменить(ТекстОповещения, "%1", Количество);
	ПоказатьОповещениеПользователя(НСтр("ru='Обмен электронными документами';uk='Обмін електронними документами'"), , ТекстОповещения);
	Элементы[ТаблицаПакетов].Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПакетыЭДНаДиск(Команда)
	
	ПрисоединенныеФайлыЭД = ПолучитьПрисоединенныеФайлыПакетовЭДНаСервере(Элементы.ВсеПакеты.ВыделенныеСтроки);
	
	МассивФайлов = Новый Массив;
	Для каждого ПрисоединенныйФайл Из ПрисоединенныеФайлыЭД Цикл
		ДанныеФайла = ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьДанныеФайла(ПрисоединенныйФайл, УникальныйИдентификатор);
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			ДанныеФайла.ИмяФайла + ".zip", ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Если МассивФайлов.Количество() Тогда
		ПустойОбработчик = Новый ОписаниеОповещения("ПустойОбработчик", ОбменСКонтрагентамиСлужебныйКлиент);
		НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВсеДокументы(Команда)
	
	ОтображатьВсеДокументы = Не ОтображатьВсеДокументы;
	Элементы.ОтображатьВсеДокументы.Пометка = ОтображатьВсеДокументы;
	УстановитьПараметрыСписка("Список","ОтображатьВсеДокументы", ОтображатьВсеДокументы);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВсеДокументыИсх(Команда)
	
	ОтображатьВсеДокументыИсх = Не ОтображатьВсеДокументыИсх;
	Элементы.ОтображатьВсеДокументыИсх.Пометка = ОтображатьВсеДокументыИсх;
	УстановитьПараметрыСписка("СписокИсх","ОтображатьВсеДокументыИсх", ОтображатьВсеДокументыИсх);
	Элементы.СписокИсх.Обновить();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыСписка(ДинамическийСписок, ИмяПараметра, ЗначениеПараметра)
	
	ЭтотОбъект[ДинамическийСписок].Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДанных, ВидЭлемента,
		ЗначениеЭлемента, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаСервере
Функция ЭтоПроизвольныйДокумент(Объект, СтруктураПараметров)
	
	Если ТипЗнч(Объект.ВладелецФайла) = Тип("ДокументСсылка.ПроизвольныйЭД") Тогда
		СтруктураПараметров = Новый Структура("Объект", Объект.ВладелецФайла);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УстановитьОтветственногоЭД(Знач СписокОбъектов, НовыйОтветственный, КоличествоОбработанныхЭД)
	
	УстановитьЗначениеРеквизитаЭД("Ответственный", СписокОбъектов, НовыйОтветственный, КоличествоОбработанныхЭД);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеРеквизитаЭД(ВидПараметра, Знач СписокОбъектов, Знач ЗначениеПараметра, КоличествоОбработанных)
	
	МассивЭД = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого ЭлСписка Из СписокОбъектов Цикл
		Если ТипЗнч(ЭлСписка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		МассивЭД.Добавить(ЭлСписка.Ссылка);
	КонецЦикла;
	
	Если МассивЭД = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидПараметра = "Ответственный" Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭДПрисоединенныеФайлы.Ссылка,
		|	ЭДПрисоединенныеФайлы.Ответственный
		|ИЗ
		|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
		|ГДЕ
		|	ЭДПрисоединенныеФайлы.Ссылка В(&МассивЭД)
		|	И ЭДПрисоединенныеФайлы.Ответственный <> &Ответственный");
		
		Запрос.УстановитьПараметр("МассивЭД",      МассивЭД);
		Запрос.УстановитьПараметр("Ответственный", ЗначениеПараметра);
	Иначе
		Возврат;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось заблокировать электронный документ (%Объект%). %ОписаниеОшибки%';uk='Не вдалося заблокувати електронний документ (%Объект%). %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%",         Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщийТекстОшибки = ОбщийТекстОшибки+Символы.ПС+ТекстОшибки;
			ОтменитьТранзакцию();
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		
		Попытка
		
			Если ВидПараметра = "Ответственный" Тогда
				СтруктураПараметров = Новый Структура("Ответственный", ЗначениеПараметра);
				ОбменСКонтрагентамиСлужебныйВызовСервера.ИзменитьПоСсылкеПрисоединенныйФайл(Выборка.Ссылка, СтруктураПараметров, Ложь);
			КонецЕсли;
			КоличествоОбработанных = КоличествоОбработанных + 1;
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось выполнить запись электронного документа (%Объект%). %ОписаниеОшибки%';uk='Не вдалося виконати запис електронного документа (%Объект%). %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Объект%",         Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщийТекстОшибки = ОбщийТекстОшибки+Символы.ПС+ТекстОшибки;
			ОтменитьТранзакцию();
			ВызватьИсключение ТекстОшибки;
		КонецПопытки
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьДанныеЭД(ТекущийСписок)
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение И НЕ ТолстыйКлиентОбычноеПриложение Тогда
		ТекстСообщения = НСтр("ru='Сравнение электронных документов можно сделать только в режиме толстого клиента.';uk='Порівняння електронних документів можна зробити тільки в режимі товстого клієнта.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	#Иначе
		Если ТекущийСписок.ТекущиеДанные = Неопределено
			ИЛИ ТекущийСписок.ВыделенныеСтроки.Количество() <> 2 Тогда
			Возврат;
		КонецЕсли;
		ТекущийЭД    = ТекущийСписок.ВыделенныеСтроки.Получить(0);
		ПослВерсияЭД = ТекущийСписок.ВыделенныеСтроки.Получить(1);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ЭДПервый", ПослВерсияЭД);
		СтруктураПараметров.Вставить("ЭДВторой", ТекущийЭД);
		ВыполнитьСравнениеЭД(СтруктураПараметров);
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусПакетов(ТаблицаПакетов, СтатусПакета, КоличествоИзмененных)
	
	КоличествоИзмененных = 0;
	Для Каждого СтрокаТаблицы Из Элементы[ТаблицаПакетов].ВыделенныеСтроки Цикл
		Попытка
			Пакет = СтрокаТаблицы.Ссылка.ПолучитьОбъект();
			Пакет.СтатусПакета = СтатусПакета;
			Пакет.Записать();
			КоличествоИзмененных = КоличествоИзмененных + 1;
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru='изменение статуса пакетов ЭД';uk='зміна статусу пакетів ЕД'"), ТекстОшибки, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПрисоединенныеФайлыПакетовЭДНаСервере(Знач ПакетыЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ВладелецФайла В (&ВладельцыФайлов)";
	Запрос.УстановитьПараметр("ВладельцыФайлов", ПакетыЭД);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	МассивФайлов = РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивФайлов;
	
КонецФункции

&НаСервере
Процедура ВыполнитьСравнениеЭД(СтруктураПараметров)
	
	#Если НЕ ТолстыйКлиентУправляемоеПриложение И НЕ ТолстыйКлиентОбычноеПриложение Тогда
		ТекстСообщения = НСтр("ru='Сравнение электронных документов можно сделать только в режиме толстого клиента.';uk='Порівняння електронних документів можна зробити тільки в режимі товстого клієнта.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	#Иначе
		
		ЭДПервый = СтруктураПараметров.ЭДПервый;
		ЭДВторой = СтруктураПараметров.ЭДВторой;
		
		Если Не (ЗначениеЗаполнено(ЭДПервый) И ЗначениеЗаполнено(ЭДВторой)) Тогда
			ТекстСообщения = НСтр("ru='Не указан один из сравниваемых электронных документов.';uk='Не вказано один з порівнюваних електронних документів.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		МассивЭД = Новый Массив;
		МассивЭД.Добавить(ЭДПервый);
		МассивЭД.Добавить(ЭДВторой);
		ПереченьВременныхФайлов = ОбменСКонтрагентамиСлужебный.ПодготовитьВременныеФайлыПросмотраЭД(МассивЭД);
		
		Если Не ЗначениеЗаполнено(ПереченьВременныхФайлов) Тогда
			ТекстСообщения = НСтр("ru='Ошибка при разборе электронного документа.';uk='Помилка при розборі електронного документа.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("mxl");
		// Необходимо заменить фрагмент от последнего подчеркивания до фрагмента ".mxl".
		ДлинаСтроки = СтрДлина(ИмяФайла);
		Для ОбратныйИндекс = 0 По ДлинаСтроки Цикл
			Если Сред(ИмяФайла, ДлинаСтроки - ОбратныйИндекс, 1) = "_" Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		НазваниеЭД = ПереченьВременныхФайлов[0].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяПервогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[0].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяПервогоФайлаMXL);
		
		НазваниеЭД = ПереченьВременныхФайлов[1].НазваниеЭД;
		СкорректироватьИмяФайла(НазваниеЭД);
		ИмяВторогоФайлаMXL = Лев(ИмяФайла, ДлинаСтроки - ОбратныйИндекс) + НазваниеЭД + Прав(ИмяФайла, 4);
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(ПереченьВременныхФайлов[1].АдресФайлаДанных);
		ТабличныйДокумент.Записать(ИмяВторогоФайлаMXL);
		
		Сравнение = Новый СравнениеФайлов;
		Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
		Сравнение.ПервыйФайл = ИмяПервогоФайлаMXL;
		Сравнение.ВторойФайл = ИмяВторогоФайлаMXL;
		Сравнение.ПоказатьРазличияМодально();
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура СкорректироватьИмяФайла(СтрИмяФайла)
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru.
	// При этом были объединены запрещенные символы для файловых систем FAT и NTFS.
	СтрИсключения = """ / \ [ ] : ; | = , ? * < >";
	СтрИсключения = СтрЗаменить(СтрИсключения, " ", "");
	
	Для Сч=1 По СтрДлина(СтрИсключения) Цикл
		Символ = Сред(СтрИсключения, Сч, 1);
		Если СтрНайти(СтрИмяФайла, Символ) <> 0 Тогда
			СтрИмяФайла = СтрЗаменить(СтрИмяФайла, Символ, " ");
		КонецЕсли;
	КонецЦикла;
	
	СтрИмяФайла = СокрЛП(СтрИмяФайла);
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоЭлементуПриЗагрузкеИзНастроек(Форма, СписокДанных, ВидЭлемента, Настройки)
	
	ЗначениеЭлемента = Настройки.Получить(ВидЭлемента);
	
	Если ЗначениеЗаполнено(ЗначениеЭлемента) Тогда
		Форма[ВидЭлемента] = ЗначениеЭлемента;
		УстановитьОтборВСпискеПоЭлементуКлиентСервер(СписокДанных, ВидЭлемента, ЗначениеЭлемента);
	КонецЕсли;
	
	Настройки.Удалить(ВидЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОСменеОтветственного(КоличествоОбработанных, СписокОбъектов, Ответственный)
	
	ОчиститьСообщения();
	
	Если КоличествоОбработанных > 0 Тогда
		
		СписокОбъектов.Обновить();
		
		ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных эл.документов
        |установлен ответственный ""%Ответственный%""'
        |;uk='Для %КоличествоОбработанных% з %КоличествоВсего% виділених ел.документів
        |встановлено відповідального ""%Ответственный%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        СписокОбъектов.ВыделенныеСтроки.Количество());
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%",          Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" установлен';uk='Відповідальний ""%Ответственный%"" встановлений'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка, , ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Ответственный ""%Ответственный%"" не установлен ни для одного эл.документа.';uk='Відповідальний ""%Ответственный%"" не встановлений для жодного ел.документа.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ответственный%", Ответственный);
		ТекстЗаголовка = НСтр("ru='Ответственный ""%Ответственный%"" не установлен';uk='Відповідальний ""%Ответственный%"" не встановлений'");
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Ответственный%", Ответственный);
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборОтветственного(НовыйОтветственный, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(НовыйОтветственный) Тогда
		КоличествоОбработанныхЭД = 0;
		УстановитьОтветственногоЭД(Элементы.Список.ВыделенныеСтроки, НовыйОтветственный,КоличествоОбработанныхЭД);
		ОповеститьПользователяОСменеОтветственного(КоличествоОбработанныхЭД, Элементы.Список, НовыйОтветственный);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

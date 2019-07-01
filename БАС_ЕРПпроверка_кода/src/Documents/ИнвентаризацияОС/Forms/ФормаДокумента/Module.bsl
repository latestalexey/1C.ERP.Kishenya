
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьРеквизитыТЧ();
		КонецЕсли;
	КонецЕсли;
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборОсновныхСредств.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "РегистрСведений.СоставКомиссий.Форма.ФормаВыбора" Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(Знач ВыбранноеЗначение)

	ДобавленныеСтроки = УчетОСВызовСервера.ОбработатьПодборОсновныхСредств(Объект.ОС, ВыбранноеЗначение);
	
	МассивОсновныхСредств = Объект.ОС.Выгрузить(ДобавленныеСтроки, "ОсновноеСредство").ВыгрузитьКолонку("ОсновноеСредство");	
	ОсновныеСредстваКоды = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОсновныхСредств, "Код");
	
	Для каждого Строка Из ДобавленныеСтроки Цикл
		
		Если ЗначениеЗаполнено(Строка.ИнвентарныйНомер) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураКоды = ОсновныеСредстваКоды.Получить(Строка.ОсновноеСредство);
		Если СтруктураКоды <> Неопределено Тогда 
			Строка.ИнвентарныйНомер = СтруктураКоды.Код;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьРеквизитыТЧ();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьРеквизитыТЧ();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОС

&НаКлиенте
Процедура ОСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование = Истина Тогда
		СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
		СтрокаТЧ.СтоимостьПоДаннымУчета = 0;
		СтрокаТЧ.НаличиеПоДаннымУчета   = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)

	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	СтрокаТЧ.СтоимостьПоДаннымУчета = 0;
	СтрокаТЧ.НаличиеПоДаннымУчета   = Ложь;

	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
		СтрокаТЧ.МОЛ = Неопределено;
	Иначе
		ДополнительныеПоля = ПолучитьДополнительныеПоляОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, ДополнительныеПоля);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОСНаличиеФактическоеПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.ОС.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.НаличиеФактическое Тогда
		Если ТекущаяСтрокаТЧ.СтоимостьФактическая = 0 Тогда
			ТекущаяСтрокаТЧ.СтоимостьФактическая = ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета;
		КонецЕсли;
	Иначе
		ТекущаяСтрокаТЧ.СтоимостьФактическая = 0;
	КонецЕсли;

	РассчитатьВычисляемыеПоляПоСтроке(ТекущаяСтрокаТЧ);

КонецПроцедуры

&НаКлиенте
Процедура ОСНаличиеПоДаннымУчетаПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.ОС.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.НаличиеПоДаннымУчета Тогда
		Если ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = 0 Тогда
			ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = ТекущаяСтрокаТЧ.СтоимостьФактическая;
		КонецЕсли;
	Иначе
		ТекущаяСтрокаТЧ.СтоимостьПоДаннымУчета = 0;
	КонецЕсли;

	РассчитатьВычисляемыеПоляПоСтроке(ТекущаяСтрокаТЧ);

КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьФактическаяПриИзменении(Элемент)

	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ОССтоимостьПоДаннымУчетаПриИзменении(Элемент)

	РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ОСПриИзменении(Элемент)

	Если Элементы.ОС.ТекущиеДанные <> Неопределено Тогда
		РассчитатьВычисляемыеПоляПоСтроке(Элементы.ОС.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыИнвентаризационнаяКомиссия

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.ИнвентаризационнаяКомиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.ИнвентаризационнаяКомиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.ИнвентаризационнаяКомиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
			Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.ИнвентаризационнаяКомиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ШаблонСообщения = НСтр("ru='Физическое лицо <%1> уже подобрано!';uk='Фізична особа <%1> вже підібрана!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ВыбранноеЗначение);
		ПоказатьПредупреждение(Неопределено, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.ИнвентаризационнаяКомиссия.Добавить();
		НоваяСтрока.ФизЛицо = ВыбранноеЗначение;
		Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.ИнвентаризационнаяКомиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияФизЛицоПриИзменении(Элемент)

	Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
		Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущаяСтрокаТЧ = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда
		СтрокиТабличнойЧасти = Объект.ИнвентаризационнаяКомиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));
		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
			ШаблонСообщения = НСтр("ru='Физическое лицо <%1> уже включено в состав комиссии!';uk='Фізична особа <%1> вже включена до складу комісії!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ВыбранноеЗначение);
			ПоказатьПредупреждение(Неопределено, ТекстСообщения, 60);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура ПодборОС(Команда)
	
	СписокСостояний = Новый Массив;
	СписокСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	СписокСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияОС.НеПринятоКУчету"));
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", СписокСостояний);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборФизическихЛиц(Команда)

	ПараметрыФормы = Новый Структура("РежимВыбора, МножественныйВыбор, ЗакрыватьПриВыборе", Истина, Ложь, Ложь);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элементы.ИнвентаризационнаяКомиссия, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	ПродолжитьЗаполнениеИзОстатков("ЗаполнитьПоОстаткам");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеУчета(Команда)
	
	ПродолжитьЗаполнениеИзОстатков("ЗаполнитьДанныеУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФактическиеДанные(Команда)
	
	ПродолжитьЗаполнениеИзОстатков("ЗаполнитьФактическиеДанные");
	
КонецПроцедуры

#Область СтандартныеПодсистемы_Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЗаполнитьРеквизитыТЧ();
	
	Для каждого Строка Из Объект.ОС Цикл
		РассчитатьВычисляемыеПоляПоСтроке(Строка);
	КонецЦикла;
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицуМОЛОС(Знач ТаблицаОС, Знач Организация, Знач Дата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаОС", ТаблицаОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
	|	МестонахождениеОСБухгалтерскийУчет.МОЛ
	|ПОМЕСТИТЬ ТаблицаМОЛ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК ТаблицаОС)) КАК МестонахождениеОСБухгалтерскийУчет
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ТаблицаМОЛ.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаМОЛ КАК ТаблицаМОЛ
	|		ПО ТаблицаОС.ОсновноеСредство = ТаблицаМОЛ.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТаблицуСчетУчетаОС(Знач ТаблицаОС, Знач Организация, Знач Дата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТаблицаОС", ТаблицаОС);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетаБухгалтерскогоУчетаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	СчетаБухгалтерскогоУчетаОС.СчетУчета
	|ПОМЕСТИТЬ ТаблицаСчетУчета
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						ТаблицаОС.ОсновноеСредство
	|					ИЗ
	|						ТаблицаОС КАК ТаблицаОС)) КАК СчетаБухгалтерскогоУчетаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ЕСТЬNULL(ТаблицаСчетУчета.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) КАК СчетУчета
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ТаблицаСчетУчета КАК ТаблицаСчетУчета
	|	ПО
	|		ТаблицаОС.ОсновноеСредство = ТаблицаСчетУчета.ОсновноеСредство
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	РезультатЗапроса = Запрос.Выполнить();

	Возврат РезультатЗапроса.Выгрузить();

КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыТЧ()
	
	ТаблицаОС = Объект.ОС.Выгрузить();
	
	ТаблицаНомеров = УчетОСВызовСервера.ПолучитьТаблицуИнвентарныхНомеровОС(ТаблицаОС,
		Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаНомеров.ВыгрузитьКолонку("ИнвентарныйНомер"), "ИнвентарныйНомер");
	
	ТаблицаМОЛ = ПолучитьТаблицуМОЛОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаМОЛ.ВыгрузитьКолонку("МОЛ"), "МОЛ");
	
	ТаблицаСчетУчета = ПолучитьТаблицуСчетУчетаОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	ТаблицаОС.ЗагрузитьКолонку(ТаблицаСчетУчета.ВыгрузитьКолонку("СчетУчета"), "СчетУчета");
	
	Объект.ОС.Загрузить(ТаблицаОС);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМОЛОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(МестонахождениеОСБухгалтерскийУчет.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК МОЛ
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК МестонахождениеОСБухгалтерскийУчет";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.МОЛ;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСчетУчетаОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(СчетаБухгалтерскогоУчетаОС.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) КАК СчетУчета
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&Дата,
	|			Организация = &Организация
	|				И ОсновноеСредство = &ОсновноеСредство) КАК СчетаБухгалтерскогоУчетаОС";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.СчетУчета;
	КонецЕсли;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДополнительныеПоляОС(Знач ОсновноеСредство, Знач Организация, Знач Дата)

	Результат = Новый Структура;
	Результат.Вставить("ИнвентарныйНомер", УчетОСВызовСервера.ПолучитьИнвентарныйНомерОС(ОсновноеСредство,
		Организация, Дата));
	Результат.Вставить("МОЛ", ПолучитьМОЛОС(ОсновноеСредство, Организация, Дата));
	Результат.Вставить("СчетУчета", ПолучитьСчетУчетаОС(ОсновноеСредство, Организация, Дата));

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВычисляемыеПоляПоСтроке(Строка)

	РазницаПоНаличию   = Число(Строка.НаличиеФактическое) - Число(Строка.НаличиеПоДаннымУчета);
	РазницаПоСтоимости = Строка.СтоимостьФактическая - Строка.СтоимостьПоДаннымУчета;

	Строка.ИзлишекКоличество = ?(РазницаПоНаличию > 0, РазницаПоНаличию, 0);
	Строка.НедостачаКоличество = ?(РазницаПоНаличию < 0, -РазницаПоНаличию, 0);
	Строка.ИзлишекСумма = ?(РазницаПоСтоимости > 0, РазницаПоСтоимости, 0);
	Строка.НедостачаСумма = ?(РазницаПоСтоимости < 0, -РазницаПоСтоимости, "");

КонецПроцедуры

&НаСервере
Функция ОстаткиОС(Знач СписокОС = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство КАК ОсновноеСредство,
		|	МестонахождениеОСБухгалтерскийУчет.Местонахождение КАК Местонахождение
		|ПОМЕСТИТЬ МестонахождениеОСБУ
		|ИЗ
		|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
		|			&ДатаОстатков,
		|			Организация = &Организация
		|				И (&БезОтбораПоСпискуОС
		|					ИЛИ ОсновноеСредство В (&СписокОС))
		|				И (&БезОтбораПоПодразделению
		|					ИЛИ Местонахождение = &Подразделение)
		|				И (&БезОтбораПоМОЛ
		|					ИЛИ МОЛ = &МОЛ)) КАК МестонахождениеОСБухгалтерскийУчет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МестонахождениеОСБУ.ОсновноеСредство КАК ОсновноеСредство,
		|	МестонахождениеОСБУ.Местонахождение КАК ПодразделениеОрганизации,
		|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
		|ПОМЕСТИТЬ ОсновныеСредства
		|ИЗ
		|	МестонахождениеОСБУ КАК МестонахождениеОСБУ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
		|				&ДатаОстатков,
		|				Организация = &Организация
		|					И (&БезОтбораПоСпискуОС
		|						ИЛИ ОсновноеСредство В (&СписокОС))) КАК СчетаБухгалтерскогоУчетаОССрезПоследних
		|		ПО МестонахождениеОСБУ.ОсновноеСредство = СчетаБухгалтерскогоУчетаОССрезПоследних.ОсновноеСредство
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	МестонахождениеОСБУ.ОсновноеСредство,
		|	МестонахождениеОСБУ.Местонахождение,
		|	ПараметрыЦелевогоФинансирования.СчетУчета,
		|	NULL
		|ИЗ
		|	МестонахождениеОСБУ КАК МестонахождениеОСБУ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыЦелевогоФинансированияОС.СрезПоследних(
		|				&ДатаОстатков,
		|				&БезОтбораПоСпискуОС
		|					ИЛИ ОсновноеСредство В (&СписокОС)) КАК ПараметрыЦелевогоФинансирования
		|		ПО МестонахождениеОСБУ.ОсновноеСредство = ПараметрыЦелевогоФинансирования.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ХозрасчетныйОстатки_ВосстановительнаяСтоимость.Субконто1 КАК Справочник.ОбъектыЭксплуатации) КАК ОсновноеСредство,
		|	СУММА(ЕСТЬNULL(ХозрасчетныйОстатки_ВосстановительнаяСтоимость.СуммаОстатокДт, 0)) КАК ВосстановительнаяСтоимость,
		|	СУММА(ЕСТЬNULL(ХозрасчетныйОстатки_НачисленнаяАмортизация.СуммаОстатокКт, 0)) КАК НачисленнаяАмортизация
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаОстатков,
		|			Счет В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					ОсновныеСредства.СчетУчета
		|				ИЗ
		|					ОсновныеСредства),
		|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|			Организация = &Организация
		|				И (Подразделение, Субконто1) В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ОсновныеСредства.ПодразделениеОрганизации,
		|						ОсновныеСредства.ОсновноеСредство
		|					ИЗ
		|						ОсновныеСредства)) КАК ХозрасчетныйОстатки_ВосстановительнаяСтоимость
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&ДатаОстатков,
		|				Счет В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ОсновныеСредства.СчетНачисленияАмортизации
		|					ИЗ
		|						ОсновныеСредства),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|				Организация = &Организация
		|					И (Подразделение, Субконто1) В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ОсновныеСредства.ПодразделениеОрганизации,
		|							ОсновныеСредства.ОсновноеСредство
		|						ИЗ
		|							ОсновныеСредства)) КАК ХозрасчетныйОстатки_НачисленнаяАмортизация
		|		ПО ХозрасчетныйОстатки_ВосстановительнаяСтоимость.Субконто1 = ХозрасчетныйОстатки_НачисленнаяАмортизация.Субконто1
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫРАЗИТЬ(ХозрасчетныйОстатки_ВосстановительнаяСтоимость.Субконто1 КАК Справочник.ОбъектыЭксплуатации)");
	
	Запрос.УстановитьПараметр("ДатаОстатков", Объект.Дата);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Подразделение", Объект.ПодразделениеОрганизации);
	Запрос.УстановитьПараметр("БезОтбораПоПодразделению", Не ЗначениеЗаполнено(Объект.ПодразделениеОрганизации));
	Запрос.УстановитьПараметр("МОЛ", Объект.МОЛ);
	Запрос.УстановитьПараметр("БезОтбораПоМОЛ", Не ЗначениеЗаполнено(Объект.МОЛ));
	Запрос.УстановитьПараметр("СписокОС", СписокОС);
	Запрос.УстановитьПараметр("БезОтбораПоСпискуОС", Не ЗначениеЗаполнено(СписокОС));
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоОстаткамСервер()

	Объект.ОС.Очистить();

	ТаблицаОС = ОстаткиОС();

	Для каждого СтрокаОС Из ТаблицаОС Цикл
		НоваяСтрока = Объект.ОС.Добавить();
		НоваяСтрока.ОсновноеСредство        = СтрокаОС.ОсновноеСредство;
		НоваяСтрока.СтоимостьПоДаннымУчета  = СтрокаОС.ВосстановительнаяСтоимость;
		НоваяСтрока.НакопленнаяАмортизация  = СтрокаОС.НачисленнаяАмортизация;
		НоваяСтрока.НаличиеПоДаннымУчета    = Истина;
		НоваяСтрока.СтоимостьФактическая    = 0;
		НоваяСтрока.НаличиеФактическое      = Ложь;
		РассчитатьВычисляемыеПоляПоСтроке(НоваяСтрока);
	КонецЦикла;

	ЗаполнитьРеквизитыТЧ();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеУчетаСервер()

	СписокОС = Объект.ОС.Выгрузить(, "ОсновноеСредство");

	ТаблицаОС = ОстаткиОС(СписокОС);
	ТаблицаОС.Индексы.Добавить("ОсновноеСредство");

	Для каждого СтрокаОС Из Объект.ОС Цикл
		ОстатокОС = ТаблицаОС.Найти(СтрокаОС.ОсновноеСредство, "ОсновноеСредство");
		Если ОстатокОС <> Неопределено Тогда
			СтрокаОС.СтоимостьПоДаннымУчета = ОстатокОС.ВосстановительнаяСтоимость;
			СтрокаОС.НаличиеПоДаннымУчета   = Истина;
		Иначе
			СтрокаОС.СтоимостьПоДаннымУчета = 0;
			СтрокаОС.НаличиеПоДаннымУчета   = Ложь;
		КонецЕсли;
		РассчитатьВычисляемыеПоляПоСтроке(СтрокаОС);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФактическиеДанныеСервер()
	
	Для каждого СтрокаОС Из Объект.ОС Цикл
		СтрокаОС.СтоимостьФактическая = СтрокаОС.СтоимостьПоДаннымУчета;
		СтрокаОС.НаличиеФактическое   = СтрокаОС.НаличиеПоДаннымУчета;
		РассчитатьВычисляемыеПоляПоСтроке(СтрокаОС);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗаполнениеИзОстатков(Действия)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Организация';uk='Організація'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Организация");
		Возврат;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(Объект.ПодразделениеОрганизации) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru='Местонахождение ОС';uk='Місцезнаходження ОЗ'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ПодразделениеОрганизации");
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='При заполнении существующие данные будут пересчитаны.
        |Продолжить?'
        |;uk='При заповненні існуючі дані будуть перераховані.
        |Продовжити?'");
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ОбработкаОтветаНаВопрос", ЭтаФорма, Новый Структура(Действия)),
		ТекстВопроса,
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопрос(Результат, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Или ДополнительныеПараметры=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ЗаполнитьПоОстаткам") Тогда
		ЗаполнитьПоОстаткамСервер();
	КонецЕсли;
	Если ДополнительныеПараметры.Свойство("ЗаполнитьДанныеУчета") Тогда
		ЗаполнитьДанныеУчетаСервер();
	КонецЕсли;
	Если ДополнительныеПараметры.Свойство("ЗаполнитьФактическиеДанные") Тогда
		ЗаполнитьФактическиеДанныеСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСоставКомиссии(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);

	ПараметрыФормы.Вставить("Отбор", Новый Структура("Организация", Объект.Организация));
	ОткрытьФорму("РегистрСведений.СоставКомиссий.Форма.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры


#КонецОбласти

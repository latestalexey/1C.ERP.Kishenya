
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.НачалоДействия = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Элементы.ГруппаБюджетыПоОрганизациям.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ГруппаБюджетыПоПодразделениям.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	
	ЭтоУправлениеПредприятием = ПолучитьФункциональнуюОпцию("УправлениеПредприятием");
	Элементы.ГруппаНастройкиБюджетногоПроцесса.Видимость = ЭтоУправлениеПредприятием;
	Элементы.ГруппаНастройкиОповещений.Видимость = ЭтоУправлениеПредприятием;
	
	Если Не ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		Элементы.ПояснениеБюджетныйПроцесс.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовФормы();

	АвтоматическиФормироватьЗадачи = Объект.АвтоматическиФормироватьЗадачи;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	Если Не РольДоступна("АдминистраторСистемы") Тогда
		Элементы.НадписьРасписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ТекущийОбъект.АвтоматическиФормироватьЗадачи = АвтоматическиФормироватьЗадачи;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	УстановитьДоступностьЭлементовФормы();
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитов

&НаКлиенте
Процедура ВложениеКОповещениюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Не ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложениеКОповещениюРезультатВыбора", ЭтаФорма, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru='Для выбора вложения к оповещению модель бюджетирования следует записать. Записать?';uk='Для вибору вкладення до оповіщення модель бюджетування слід записати. Записати?'"), РежимДиалогаВопрос.ДаНет, 60);
		Возврат;
	КонецЕсли;
	
	ВложениеКОповещениюЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма,,Новый ОписаниеОповещения("ОповещениеОРазблокировке", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПодготовкиБюджетов(Команда)
	
	//++ НЕ УТКА
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) ИЛИ Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru='Для настройки бюджетного процесса необходимо записать объект. Записать?';uk='Для настройки бюджетного процесу необхідно записати об''єкт. Записати?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ПланПодготовкиБюджетовЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ПланПодготовкиБюджетовФрагмент();
	
	//-- НЕ УТКА
	
	Возврат; //Не используется в КА и УТ
	
КонецПроцедуры

//++ НЕ УТКА

&НаКлиенте
Процедура ПланПодготовкиБюджетовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЭлементЗаписан = Записать();
	Иначе 
		Возврат
	КонецЕсли;
	
	Если Не ЭлементЗаписан Тогда
		Возврат;
	КонецЕсли;
	
	ПланПодготовкиБюджетовФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланПодготовкиБюджетовФрагмент()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Объект.Ссылка));
	
	ОткрытьФорму("Справочник.ЭтапыПодготовкиБюджетов.ФормаСписка", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

//-- НЕ УТКА

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "НачалоДействия", "КонецДействия"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповещениеОРазблокировке(Результат, ДополнительныеПараметры) Экспорт
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	//Механизм блокировки заблокировал реквизиты
	Элементы.ФормироватьЗадачиАвтоматически.ТолькоПросмотр = Элементы.НачалоДействия.ТолькоПросмотр;
	Элементы.ЗапускатьДокументом.ТолькоПросмотр = Элементы.НачалоДействия.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьРасписаниеНажатие(Элемент)
	
	ПараметрыФормы = ПолучитьПараметрыФормыНастройкиРегламентногоЗадания();
	ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание",
		ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыФормыНастройкиРегламентногоЗадания()
	
	ПараметрыФормы = Неопределено;
	
	//++ НЕ УТКА
	
	РегламентноеЗадание = 
		РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ФормированиеБюджетныхЗадач);
	ПараметрыФормы = Новый Структура("Действие, Идентификатор","Изменить",РегламентноеЗадание.УникальныйИдентификатор);
	
	//-- НЕ УТКА
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ВложениеКОповещениюРезультатВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Записать();
	ВложениеКОповещениюЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложениеКОповещениюЗавершение(ДополнительныеПараметры)
	
	ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(Объект.Ссылка, ДополнительныеПараметры.Элемент);
	
КонецПроцедуры

#КонецОбласти

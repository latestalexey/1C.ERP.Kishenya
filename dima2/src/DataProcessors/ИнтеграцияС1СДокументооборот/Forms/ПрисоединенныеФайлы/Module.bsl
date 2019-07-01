#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Владелец", Владелец);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОжидаетсяПодключение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияС1СДокументооборотКлиент.УстановитьЗаголовокПриОткрытии(ЭтаФорма);
	
	ПроверитьПодключение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтаФорма);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот";
	 
	ОткрытьФорму(ИмяФормыПараметров,, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандТаблицыФайлы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьНаЧтение(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьКарточку();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ДобавитьСДиска(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = "";
	
	Если Элементы.Файлы.ВыделенныеСтроки.Количество() = 1 Тогда
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Снять с ""%1"" пометку на удаление?';uk='Зняти з ""%1"" позначку на вилучення?'"), ТекущиеДанные.Наименование);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Пометить ""%1"" на удаление?';uk='Відмітити ""%1"" для вилучення?'"), ТекущиеДанные.Наименование);
		КонецЕсли;
	Иначе
		Если ТекущиеДанные.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru='Снять с выделенных файлов пометку на удаление?';uk='Зняти з виділених файлів позначку на вилучення?'");
		Иначе
			ТекстВопроса = НСтр("ru='Пометить выделенные файлы на удаление?';uk='Позначити виділені файли на вилучення?'");
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ВыделенныеСтроки", Элементы.Файлы.ВыделенныеСтроки);
	Оповещение = Новый ОписаниеОповещения(
		"ФайлыПередУдалениемЗавершение", ЭтаФорма, ДополнительныеПараметры);
	
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(Оповещение, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСДиска(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьСДискаЗавершение", ЭтаФорма);
	Если ЗначениеЗаполнено(ID) Тогда // связанный объект уже известен
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	Иначе // связанный объект следует найти или создать
		ИнтеграцияС1СДокументооборотКлиент.НачатьПоискСвязанногоОбъектаДО(Владелец, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСДискаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ID = Результат.id;
		Тип = Результат.type;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ID) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.СоздатьФайлСДиска(УникальныйИдентификатор, ID, Тип,
		Строка(Владелец), ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПечатнуюФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПечатнуюФормуЗавершение", ЭтаФорма);
	Если ЗначениеЗаполнено(ID) Тогда // связанный объект уже известен
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	Иначе // связанный объект следует найти или создать
		ИнтеграцияС1СДокументооборотКлиент.НачатьПоискСвязанногоОбъектаДО(Владелец, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПечатнуюФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ID = Результат.id;
		Тип = Результат.type;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ID) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектИС", Владелец);
	ПараметрыФормы.Вставить("ИдентификаторОбъектаДО", ID);
	ПараметрыФормы.Вставить("ТипОбъектаДО", Тип);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеПечатнойФормыЗавершение", ЭтаФорма);
	ФормаДобавления = ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборот.Форма.ДобавлениеПечатнойФормы", 
		ПараметрыФормы, ЭтаФорма,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Если ФормаДобавления = Неопределено Тогда
		ТекстПредупрежедения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 не имеет печатных форм.';uk='%1 не має друкованих форм.'"), Строка(Владелец));
		ПоказатьПредупреждение(, ТекстПредупрежедения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаЧтение(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьФайл(ТекущиеДанные.ID, ТекущиеДанные.Наименование,
			ТекущиеДанные.Расширение, УникальныйИдентификатор, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляРедактирования(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьФайл(ТекущиеДанные.ID, ТекущиеДанные.Наименование, 
			ТекущиеДанные.Расширение, УникальныйИдентификатор, Ложь, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотКлиент.ЗакончитьРедактированиеФайла(
			ТекущиеДанные.ID, ТекущиеДанные.Наименование, ТекущиеДанные.Расширение, 
			УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаДиск(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.СохранитьФайлКак(ТекущиеДанные.ID, 
			ТекущиеДанные.Наименование, ТекущиеДанные.Расширение, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотКлиент.ОбновитьИзФайлаНаДиске(
			ТекущиеДанные.ID, ТекущиеДанные.Наименование, ТекущиеДанные.Расширение, 
			УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотКлиент.ОтменитьРедактированиеФайла(
			ТекущиеДанные.ID, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтотОбъект);
		ИнтеграцияС1СДокументооборотКлиент.СохранитьИзмененияРедактируемогоФайла(
			ТекущиеДанные.ID, ТекущиеДанные.Наименование, ТекущиеДанные.Расширение, 
			УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокФайловКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	ОбновитьСписокФайловКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодключениеЗавершение", ЭтаФорма, Неопределено);
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(
		ОписаниеОповещения, ЭтаФорма, "ПроверитьПодключение");
	
КонецПроцедуры

// Вызывается после проверки подключения к ДО и изменяет форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	ОбработатьФормуСогласноВерсииСервиса();
	
КонецПроцедуры

// Изменяет форму согласно доступности сервиса ДО и номеру его версии.
//
&НаСервере
Процедура ОбработатьФормуСогласноВерсииСервиса()
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборот.ВерсияСервиса();
	
	Если ПустаяСтрока(ВерсияСервиса) Тогда // идет подключение
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОжидаетсяПодключение;
		Элементы.СтраницаОжидаетсяПодключение.Видимость = Истина;
		
	Иначе // версия известна
		
		Если ВерсияСервиса = "0.0.0.0" Тогда
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДокументооборотНедоступен;
			Элементы.СтраницаОжидаетсяПодключение.Видимость = Ложь;
			
		Иначе
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДокументооборотДоступен;
			
			ДоступенЗахватФайлов = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса(
				"1.4.9.1");
			
			ДоступныПомеченныеНаУдаление = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса(
				"2.0.6.3");
				
			СостояниеРазрешаетДобавлениеФайла = Истина;
			СостояниеРазрешаетРедактированиеФайла = Ложь;
			
			ДанныеОбъектаДО = ИнтеграцияС1СДокументооборотВызовСервера.
				ДанныеОбъектаДОПоВнешнемуОбъекту(Владелец);
			Если ДанныеОбъектаДО <> Неопределено Тогда
				ID = ДанныеОбъектаДО.id;
				Тип = ДанныеОбъектаДО.type;
				ПрочитатьИОбновитьСписокФайлов();
			КонецЕсли;
			
			Элементы.ДобавитьПечатнуюФорму.Доступность = СостояниеРазрешаетДобавлениеФайла;
			Элементы.ДобавитьСДиска.Доступность = СостояниеРазрешаетДобавлениеФайла;
			
			Элементы.ОткрытьДляРедактирования.Доступность = СостояниеРазрешаетРедактированиеФайла;
			Элементы.ЗакончитьРедактирование.Доступность = СостояниеРазрешаетРедактированиеФайла;
			Элементы.ОбновитьИзФайлаНаДиске.Доступность = СостояниеРазрешаетРедактированиеФайла;
			Элементы.СохранитьИзменения.Доступность = СостояниеРазрешаетРедактированиеФайла;
			
			Элементы.ПоказыватьУдаленные.Видимость = ДоступныПомеченныеНаУдаление;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Общее завершение команд редактирования. Обновляет форму.
//
&НаКлиенте
Процедура КомандыРедактированияЗавершение(Результат, Параметры) Экспорт
	
	ОбновитьСписокФайловКлиент();
	
КонецПроцедуры

// Завершает добавление печатной формы владельца. Обновляет форму.
&НаКлиенте
Процедура ДобавлениеПечатнойФормыЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		ОбновитьСписокФайловКлиент(Результат[0].Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Обновляет список файлов, заново получая его из ДО.
//
&НаКлиенте
Процедура ОбновитьСписокФайловКлиент(ИдентификаторФайла = Неопределено)
	
	Если ИдентификаторФайла <> Неопределено Тогда
		ТекущийИдентификаторФайла = ИдентификаторФайла;
	ИначеЕсли Элементы.Файлы.ТекущиеДанные <> Неопределено Тогда
		ТекущийИдентификаторФайла = Элементы.Файлы.ТекущиеДанные.ID;
	КонецЕсли;
	
	ПрочитатьИОбновитьСписокФайлов();
	
	// Восстановим положение в списке.
	Для Каждого Строка Из Файлы Цикл
		Если Строка.ID = ТекущийИдентификаторФайла Тогда
			Элементы.Файлы.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Получает список файлов из ДО и обновляет список.
&НаСервере
Процедура ПрочитатьИОбновитьСписокФайлов()
	
	Файлы.Очистить();
	
	Если Не ЗначениеЗаполнено(ID) Тогда
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектИд = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRetrieveRequest");
	Запрос.objectIds.Добавить(ОбъектИд);
	Запрос.columnSet.Добавить("files");
	
	Если Тип = "DMInternalDocument"
		Или Тип = "DMIncomingDocument"
		Или Тип = "DMOutgoingDocument" Тогда
		Запрос.columnSet.Добавить("enabledProperties");
	КонецЕсли;
	
	Если ПоказыватьУдаленные Тогда
		Запрос.columnSet.Добавить("ignoreDeletionMark");
	КонецЕсли;
	
	Результат = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);

	ОбъектXDTO = Результат.objects[0];
	ИнтеграцияС1СДокументооборотВызовСервера.ОбновитьСписокФайлов(ОбъектXDTO.files, Файлы);
	
	// Уточним доступность команд добавления и редактирования.
	СостояниеРазрешаетДобавлениеФайла = Истина;
	СостояниеРазрешаетРедактированиеФайла = Истина;
	Если ОбъектXDTO.Свойства().Получить("enabledProperties") <> Неопределено
		И ОбъектXDTO.enabledProperties.Количество() <> 0 Тогда
		СостояниеРазрешаетДобавлениеФайла = Ложь;
		СостояниеРазрешаетРедактированиеФайла = Ложь;
		Для Каждого ДоступноеПоле из ОбъектXDTO.enabledProperties Цикл
			Если НРег(ДоступноеПоле) = "addfile" Тогда
				СостояниеРазрешаетДобавлениеФайла = Истина;
			ИначеЕсли НРег(ДоступноеПоле) = "editfile" Тогда
				СостояниеРазрешаетРедактированиеФайла = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Открывает карточку выбранного файла.
//
&НаКлиенте
Процедура ОткрытьКарточку()
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РазрешеноРедактирование",
			СостояниеРазрешаетРедактированиеФайла);
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект("DMFile", ТекущиеДанные.ID,
			ЭтаФорма, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Завершает удаление файла после вопроса пользователю.
//
&НаКлиенте
Процедура ФайлыПередУдалениемЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПометитьНаУдаление(ПараметрыОповещения.ВыделенныеСтроки);
		ОбновитьСписокФайловКлиент();
	КонецЕсли; 
	
КонецПроцедуры

// Помечает на удаление выделенные файлы.
//
&НаСервере
Процедура ПометитьНаУдаление(Знач ВыделенныеСтроки)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMDeleteRequest");
	
	Для Каждого НомерСтроки Из ВыделенныеСтроки Цикл
		Данные = Файлы.НайтиПоИдентификатору(НомерСтроки);
		ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, Данные.ID, "DMFile");
		Запрос.objectIds.Добавить(ОбъектXDTO);
	КонецЦикла;
	
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
КонецПроцедуры

// Меняет доступность команд в завимости от выбранного файла.
//
&НаКлиенте
Процедура УстановитьДоступностьКомандСпискаФайлов()
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		
		Элементы.ОткрытьНаЧтение.Доступность = Ложь;
		Элементы.ОткрытьДляРедактирования.Доступность = Ложь;
		Элементы.ЗакончитьРедактирование.Доступность = Ложь;
		Элементы.СохранитьНаДиск.Доступность = Ложь;
		Элементы.ОбновитьИзФайлаНаДиске.Доступность = Ложь;
		Элементы.СохранитьИзменения.Доступность = Ложь;
		Элементы.ОтменитьРедактирование.Доступность = Ложь;
		Элементы.ОткрытьКарточку.Доступность = Ложь;
		Элементы.Удалить.Доступность = Ложь;
		
	Иначе
		
		Редактируется = ТекущиеДанные.Редактируется;
		РедактируетсяТекущимПользователем = ТекущиеДанные.РедактируетсяТекущимПользователем;
		РедактируетсяДругимПользователем = Редактируется И НЕ РедактируетсяТекущимПользователем;
		
		Элементы.ОткрытьНаЧтение.Доступность = Истина;
		Элементы.ОткрытьДляРедактирования.Доступность = СостояниеРазрешаетРедактированиеФайла
			И ДоступенЗахватФайлов И НЕ РедактируетсяДругимПользователем;
		Элементы.ЗакончитьРедактирование.Доступность = СостояниеРазрешаетРедактированиеФайла
			И ДоступенЗахватФайлов И РедактируетсяТекущимПользователем;
		Элементы.СохранитьИзменения.Доступность = СостояниеРазрешаетРедактированиеФайла
			И ДоступенЗахватФайлов И РедактируетсяТекущимПользователем;
		Элементы.ОтменитьРедактирование.Доступность = СостояниеРазрешаетРедактированиеФайла
			И ДоступенЗахватФайлов И РедактируетсяТекущимПользователем;
		Элементы.СохранитьНаДиск.Доступность = Истина;
		Элементы.ОбновитьИзФайлаНаДиске.Доступность = СостояниеРазрешаетРедактированиеФайла
			И НЕ РедактируетсяДругимПользователем;
		Элементы.ОткрытьКарточку.Доступность = Истина;
		Элементы.Удалить.Доступность = СостояниеРазрешаетРедактированиеФайла
			И НЕ РедактируетсяДругимПользователем;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
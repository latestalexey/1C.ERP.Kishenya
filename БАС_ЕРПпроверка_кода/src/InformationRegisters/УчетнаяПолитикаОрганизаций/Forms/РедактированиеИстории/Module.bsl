
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	
	ЗаполнитьМесяцПоДатеВТабличнойЧасти(НаборЗаписей, "Период", "ПериодСтрокой");
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Элемент.ТекущиеДанные.Организация = ОбъектВладелец;
			НовыйПериод = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
			Иначе
				ПоследнийПериод = '00010101000000';
			КонецЕсли; 
			Если НовыйПериод <= ПоследнийПериод Тогда
				НовыйПериод = ДобавитьМесяц(ПоследнийПериод, 1);
			КонецЕсли; 
			Элемент.ТекущиеДанные.Период = НовыйПериод;
			ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru='Необходимо указать месяц, с которого будет действовать настройка';uk='Необхідно вказати місяць, з якого буде діяти настройка'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru='Уже есть запись с указанным месяцем начала действия настройки';uk='Вже є запис з зазначеним місяцем початку дії настройки'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокойПриИзменении(Элемент)
	
	ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВводМесяцаНачалоВыбора(ЭтаФорма, Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "УчетнаяПолитикаОрганизаций", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДатаСеанса()
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Возврат ТекущаяДатаСеанса();
	#Иначе
		Возврат ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
	
КонецФункции

&НаСервере
Процедура ЗаполнитьМесяцПоДатеВТабличнойЧасти(ДанныеТабличнойЧасти, ПутьРеквизита, ПутьРеквизитаПредставления)
	
	Для Каждого СтрокаТабличнойЧасти Из ДанныеТабличнойЧасти Цикл
		Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(СтрокаТабличнойЧасти, ПутьРеквизита);
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(СтрокаТабличнойЧасти,
																					ПутьРеквизитаПредставления,
																					ПолучитьПредставлениеМесяца(Значение));
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеМесяца(Знач ДатаНачалаМесяца)
	
	Возврат Формат(ДатаНачалаМесяца, "ДФ='ММММ гггг'");
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьМесяцПоДате(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления)
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, ПолучитьПредставлениеМесяца(Значение));
	
КонецПроцедуры

&НаКлиенте
Процедура ВводМесяцаПриИзменении(РедактируемыйОбъект, ПутьРеквизита, ПутьРеквизитаПредставления, Модифицированность = Ложь)
	
	ЗначениеПредставления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления);
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	ДатаКакМесяцПодобратьДатуПоТексту(ЗначениеПредставления, Значение);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект,
																				ПутьРеквизитаПредставления,
																				ПолучитьПредставлениеМесяца(Значение));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	
	Модифицированность = Истина;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВводМесяцаНачалоВыбора(	Форма,
											РедактируемыйОбъект,
											ПутьРеквизита,
											ПутьРеквизитаПредставления,
											ИзменитьМодифицированность = Истина,
											ОповещениеЗавершения = Неопределено)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("РедактируемыйОбъект", РедактируемыйОбъект);
	ДополнительныеПараметры.Вставить("ПутьРеквизита", ПутьРеквизита);
	ДополнительныеПараметры.Вставить("ПутьРеквизитаПредставления", ПутьРеквизитаПредставления);
	ДополнительныеПараметры.Вставить("ИзменитьМодифицированность", ИзменитьМодифицированность);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	
	Оповещение = Новый ОписаниеОповещения("ВводМесяцаНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода", 
		Новый Структура("Значение,РежимВыбораПериода,ЗапрашиватьРежимВыбораПериодаУВладельца", Значение, "Месяц", Ложь),
		Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводМесяцаРегулирование(	РедактируемыйОбъект,
											ПутьРеквизита,
											ПутьРеквизитаПредставления,
											Направление,
											Модифицированность = Ложь)
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита);
	Значение = ДобавитьМесяц(Значение, Направление);
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект,
																				ПутьРеквизита,
																				Значение);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект,
																				ПутьРеквизитаПредставления,
																				ПолучитьПредставлениеМесяца(Значение));
	
	Модифицированность = Истина;
 	
КонецПроцедуры 

&НаКлиенте
Процедура ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Не ПустаяСтрока(Текст) Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если Текст <> "" Тогда
		ДанныеВыбора = ДатаКакМесяцПодобратьДатуПоТексту(Текст);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДатаКакМесяцПодобратьДатуПоТексту(Текст, ДатаПоТексту = НеОпределено)
	
	СписокВозврата = Новый СписокЗначений;
	ТекущийГод = Год(ДатаСеанса());
	
	Если ПустаяСтрока(Текст) Тогда
		ДатаПоТексту = Дата(1, 1, 1);
		Возврат СписокВозврата;
	КонецЕсли;
	
	Если СтрНайти(Текст, ".") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ".");
	ИначеЕсли СтрНайти(Текст, ",") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, ",");
	ИначеЕсли СтрНайти(Текст, "-") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "-");
	ИначеЕсли СтрНайти(Текст, "/") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "/");
	ИначеЕсли СтрНайти(Текст, "\") <> 0 Тогда
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, "\");
	Иначе
		Подстроки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Текст, " ");
	КонецЕсли;
	
	Если Подстроки.Количество() = 1 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Текст) Тогда
			МесяцЧислом = Число(Текст);
			Если МесяцЧислом >= 1 и МесяцЧислом <=12 Тогда
				ДатаПоТексту = Дата(ТекущийГод, МесяцЧислом, 1);
				Если СтрДлина(Текст) = 1 Тогда
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='М/гг'"));
				Иначе
					СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММ/гг'"));
				КонецЕсли;
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
		Иначе
			СписокМесяцев = СписокМесяцевПоСтроке(Текст);
			Для Каждого Месяц Из СписокМесяцев Цикл
				ДатаПоТексту = Дата(ТекущийГод, Месяц, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли Подстроки.Количество() = 2 Тогда
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[1]) Тогда
			
			Если ПустаяСтрока(Подстроки[1]) Тогда
				ГодЧислом = 0;
				Подстроки[1] = "0";
				ТекстВозврата = Текст + "0";
			Иначе
				ГодЧислом = Число(Подстроки[1]);
				ТекстВозврата = "";
			КонецЕсли;
			
			Если ГодЧислом > 3000 Тогда
				Возврат СписокВозврата;
			КонецЕсли;
			
			Если СтрДлина(Подстроки[1]) <= 1 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 3) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 2 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 2) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 3 Тогда
				ГодЧислом = Число(Лев(Формат(ТекущийГод, "ЧГ="), 1) + Подстроки[1]);
			ИначеЕсли СтрДлина(Подстроки[1]) = 4 Тогда
				ГодЧислом = Число(Подстроки[1]);
			КонецЕсли;                    
			
		Иначе
			
			Возврат СписокВозврата;
			
		КонецЕсли;                
		Если ЗначениеЗаполнено(Подстроки[0]) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Подстроки[0]) Тогда
			
			МесяцЧислом = Число(Подстроки[0]);
			Если МесяцЧислом >= 1 и МесяцЧислом <= 12 Тогда
				ДатаПоТексту = Дата(ГодЧислом, МесяцЧислом, 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Возврат СписокВозврата;
			КонецЕсли;                
			
		Иначе
			
			СписокМесяцев = СписокМесяцевПоСтроке(Подстроки[0]);
			
			Если СписокМесяцев.Количество() = 1 Тогда
				ДатаПоТексту = Дата(ГодЧислом, СписокМесяцев[0], 1);
				СписокВозврата.Добавить(Формат(ДатаПоТексту, "ДФ='ММММ гггг'"));
			Иначе
				Для Каждого Месяц Из СписокМесяцев Цикл
					ДатаПоТексту = Дата(ГодЧислом, Месяц, 1);
					СписокВозврата.Добавить(Формат(Дата(ГодЧислом, Месяц, 1), "ДФ='ММММ гггг'"));
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокВозврата;
	
КонецФункции

&НаКлиенте
Функция СписокМесяцевПоСтроке(Текст)
	
	СписокМесяцев  = Новый СписокЗначений;
	Месяцы         = Новый Соответствие;
	МесяцыВозврата = Новый Массив;
	
	Для Счетчик = 1 По 12 Цикл
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='ММММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
		Представление = Формат(Дата(2000, Счетчик, 1), "ДФ='МММ'");
		СписокМесяцев.Добавить(Счетчик, Представление);
	КонецЦикла;
	
	Для Каждого ЭлементСписка Из СписокМесяцев Цикл
		Если ВРег(Текст) = ВРег(Лев(ЭлементСписка.Представление, СтрДлина(Текст))) Тогда
			Месяцы[ЭлементСписка.Значение] = 0;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Элемент Из Месяцы Цикл
		МесяцыВозврата.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Возврат МесяцыВозврата;
	
КонецФункции

&НаКлиенте
Процедура ВводМесяцаНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	РедактируемыйОбъект = ДополнительныеПараметры.РедактируемыйОбъект;
	ПутьРеквизита = ДополнительныеПараметры.ПутьРеквизита;
	ПутьРеквизитаПредставления = ДополнительныеПараметры.ПутьРеквизитаПредставления;
	ИзменитьМодифицированность = ДополнительныеПараметры.ИзменитьМодифицированность;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Ложь);
		КонецЕсли;
		Возврат;
	КонецЕсли;
		
	Значение = ВыбранноеЗначение;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизита, Значение);
	Представление = ПолучитьПредставлениеМесяца(Значение);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(РедактируемыйОбъект, ПутьРеквизитаПредставления, Представление);
	
	Если ИзменитьМодифицированность Тогда 
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

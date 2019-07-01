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
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		
		ТолькоПросмотр = Истина;
		
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
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(НаборЗаписей, "Период", "ПериодСтрокой");
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Элемент.ТекущиеДанные.ФизическоеЛицо = ОбъектВладелец;
			Элемент.ТекущиеДанные.НаличиеГарантий = Истина;
			Элемент.ТекущиеДанные.Период = ОбщегоНазначенияКлиент.ДатаСеанса();
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
			ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru='Необходимо указать месяц, с которого будет действовать запись сведений';uk='Необхідно вказати місяць, з якого буде діяти запис відомостей'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru='Уже есть запись с указанным месяцем сведений';uk='Вже є запис з зазначеним місяцем дані'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru='Необходимо указать месяц регистрации изменений';uk='Необхідно вказати місяць реєстрації змін'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.ДатаРегистрацииИзмененийСтрокой", , Отказ);
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
Процедура НаборЗаписейПериодСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("УстановитьДатуРегистрацииИзмененийПоПериоду", ЭтотОбъект);
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой",, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "СведенияОЛицахСДополнительнымиГарантиями", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти



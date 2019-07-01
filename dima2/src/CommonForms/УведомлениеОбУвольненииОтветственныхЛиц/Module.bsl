#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("СведенияОбОтветственных") Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОбОтветственных = Параметры.СведенияОбОтветственных;
	
	Если Не ЗначениеЗаполнено(СведенияОбОтветственных)
		ИЛИ СведенияОбОтветственных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ИнициализироватьФорму(СведенияОбОтветственных);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ОбработкаНавигационнойСсылки(Элемент, 
	
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИндексСтруктурнойЕдиницы = Число(Сред(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина("СтруктурнаяЕдиница") + 1));
	СтруктурнаяЕдиница = СтруктурныеЕдиницы[ИндексСтруктурнойЕдиницы].Значение;
	
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуНастройкиОтветственныхЛиц(СтруктурнаяЕдиница);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьФорму(СведенияОбОтветственных)
	
	ОдноФизическоеЛицо = Истина;
	ГруппаСообщений = Элементы.Найти("ГруппаСообщений");
	
	ФизическиеЛица = Новый Соответствие;
	Для каждого КлючИЗначение Из СведенияОбОтветственных Цикл
		
		Для каждого ЭлементСписка Из КлючИЗначение.Значение Цикл
			
			СведенияФизическогоЛица = ФизическиеЛица.Получить(ЭлементСписка.Значение);
			Если СведенияФизическогоЛица = Неопределено Тогда
				СведенияФизическогоЛица = Новый Соответствие;
			КонецЕсли;
			
			СведенияОрганизации = СведенияФизическогоЛица.Получить(КлючИЗначение.Ключ);
			Если СведенияОрганизации = Неопределено Тогда
				СведенияОрганизации = Новый Массив;
			КонецЕсли;
			СведенияОрганизации.Добавить(ЭлементСписка.Представление);
			
			СведенияФизическогоЛица.Вставить(КлючИЗначение.Ключ, СведенияОрганизации);
			ФизическиеЛица.Вставить(ЭлементСписка.Значение, СведенияФизическогоЛица);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если ФизическиеЛица.Количество() > 1 Тогда
		ОдноФизическоеЛицо = Ложь;
	КонецЕсли; 
	
	ИндексСтруктурнойЕдиницы = 0;
	
	Если ОдноФизическоеЛицо Тогда
		
		СведенияОбОтветственномВыведены = Ложь;
		Для каждого СведенияОбОтветственных Из ФизическиеЛица Цикл
			
			Для каждого Сведения Из СведенияОбОтветственных.Значение Цикл
				
				Если Сведения.Значение.Количество() > 1 Тогда
					
					Если Не СведенияОбОтветственномВыведены Тогда
						
						СведенияОбОтветственномВыведены = Истина;
						ТекстСообщения = Новый ФорматированнаяСтрока(
							Новый ФорматированнаяСтрока(Строка(СведенияОбОтветственных.Ключ), Новый Шрифт(,, Истина)),
							" " + НСтр("ru='входит в число ответственных лиц';uk='входить в число відповідальних осіб'"));
						
					Иначе
						ТекстСообщения = "";
					КонецЕсли; 
					
					ТекстСообщения = Новый ФорматированнаяСтрока(
						ТекстСообщения,
						":");
					
					Для каждого ЭлементСведений Из Сведения.Значение Цикл
						
						ТекстСообщения = Новый ФорматированнаяСтрока(
							ТекстСообщения,
							Символы.ПС,
							"    - " + ЭлементСведений);
						
					КонецЦикла;
					
					ТекстСообщения = Новый ФорматированнаяСтрока(
						ТекстСообщения,
						Символы.ПС);
					
				Иначе
					
					Если Не СведенияОбОтветственномВыведены Тогда
						
						СведенияОбОтветственномВыведены = Истина;
						ТекстСообщения = Новый ФорматированнаяСтрока(
							Новый ФорматированнаяСтрока(Строка(СведенияОбОтветственных.Ключ), Новый Шрифт(,, Истина)),
							" " + НСтр("ru='входит в число ответственных лиц';uk='входить в число відповідальних осіб'"));
						
					Иначе
						ТекстСообщения = "";
					КонецЕсли; 
					
					ТекстСообщения = Новый ФорматированнаяСтрока(
						ТекстСообщения,
						Символы.ПС + "(" + Сведения.Значение[0] + ") ");
					
				КонецЕсли;
				
				ТекстСообщения = Новый ФорматированнаяСтрока(
					ТекстСообщения,
					НСтр("ru='в';uk='в'") + " ",
					Новый ФорматированнаяСтрока(Строка(Сведения.Ключ), Новый Шрифт(,, Истина, Истина)),
					" ",
					Новый ФорматированнаяСтрока(НСтр("ru='Изменить...';uk='Змінити...'"), , , , "СтруктурнаяЕдиница" + ИндексСтруктурнойЕдиницы));
				
				ИндексСтруктурнойЕдиницы = ИндексСтруктурнойЕдиницы + 1;
				СтруктурныеЕдиницы.Добавить(Сведения.Ключ);
				Декорация = Элементы.Добавить("Декорация" + ИндексСтруктурнойЕдиницы, Тип("ДекорацияФормы"), ГруппаСообщений);
				Декорация.Вид = ВидДекорацииФормы.Надпись;
				Декорация.Заголовок = ТекстСообщения;
				Декорация.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
				
			КонецЦикла;
			
		КонецЦикла;
		
	Иначе
		
		Для каждого КлючИЗначение Из СведенияОбОтветственных Цикл
			
			ТекстСообщения = Новый ФорматированнаяСтрока(
				НСтр("ru='По';uk='По'") + " ",
				Новый ФорматированнаяСтрока(Строка(КлючИЗначение.Ключ), Новый Шрифт(,, Истина, Истина)),
				" ");
			
			Если КлючИЗначение.Значение.Количество() = 1 Тогда
				
				ТекстСообщения = Новый ФорматированнаяСтрока(
					ТекстСообщения,
					НСтр("ru='уволено ответственное лицо';uk='звільнено відповідальна особа'") + " ",
					Новый ФорматированнаяСтрока(Строка(КлючИЗначение.Значение[0].Значение), Новый Шрифт(,, Истина)),
					" (" + КлючИЗначение.Значение[0].Представление + ")");
				
			Иначе
				
				ТекстСообщения = Новый ФорматированнаяСтрока(
					ТекстСообщения,
					НСтр("ru='уволены ответственные лица';uk='звільнені відповідальні особи'"));
				
				Для каждого ОписаниеОтветственного Из КлючИЗначение.Значение Цикл
					
					ТекстСообщения = Новый ФорматированнаяСтрока(
						ТекстСообщения,
						Символы.ПС + "    - ",
						Новый ФорматированнаяСтрока(Строка(ОписаниеОтветственного.Значение), Новый Шрифт(,, Истина)),
						" (" + ОписаниеОтветственного.Представление + ")");
					
				КонецЦикла;
				
			КонецЕсли;
			
			ТекстСообщения = Новый ФорматированнаяСтрока(
				ТекстСообщения,
				Символы.ПС,
				Новый ФорматированнаяСтрока(НСтр("ru='Изменить...';uk='Змінити...'"), , , , "СтруктурнаяЕдиница" + ИндексСтруктурнойЕдиницы));
			
			ИндексСтруктурнойЕдиницы = ИндексСтруктурнойЕдиницы + 1;
			СтруктурныеЕдиницы.Добавить(КлючИЗначение.Ключ);
			
			Декорация = Элементы.Добавить("Декорация" + ИндексСтруктурнойЕдиницы, Тип("ДекорацияФормы"), ГруппаСообщений);
			Декорация.Вид = ВидДекорацииФормы.Надпись;
			Декорация.Заголовок = ТекстСообщения;
			Декорация.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОбработкаНавигационнойСсылки");
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

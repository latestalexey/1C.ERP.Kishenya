
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СвойстваПоКатегориям = Новый ФиксированноеСоответствие(ПланыВидовРасчета.Начисления.СвойстваНачисленийПоКатегориям());
	
	ЗаполнитьНаСервере();
	
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНачисленияНДФЛ

&НаКлиенте
Процедура НачисленияКодДоходаНДФЛОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияКодДоходаНДФЛОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНДФЛНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для Каждого ИдентификаторСтроки Из ПараметрыПеретаскивания.Значение Цикл 
		
		ТекСтрока = НачисленияНДФЛ.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ТекСтрока.ТолькоПросмотр Тогда
			Выполнение = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНДФЛПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПолученныйМассив = ПараметрыПеретаскивания.Значение;
	
	Если ТипЗнч(ПолученныйМассив) = Тип("Массив") Тогда
		
		Для Каждого ЭлементМассива Из ПолученныйМассив Цикл
			
			Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда 
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецЕсли;	
			
			НоваяСтрока = НачисленияНДФЛ.Добавить();
            ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			
			НачисленияНеНДФЛ.Удалить(ЭлементМассива);
			
		КонецЦикла;
		
	КонецЕсли;
	
	НачисленияНДФЛ.Сортировать("РеквизитДопУпорядочивания");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНДФЛВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНДФЛПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	УстановитьПараметрыВыбораКодаДоходаНДФЛ();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНДФЛПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНачисленияНеНДФЛ

&НаКлиенте
Процедура НачисленияНеНДФЛНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для Каждого ИдентификаторСтроки Из ПараметрыПеретаскивания.Значение Цикл 
		
		ТекСтрока = НачисленияНеНДФЛ.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ТекСтрока.ТолькоПросмотр Тогда
			Выполнение = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеНДФЛПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПолученныйМассив = ПараметрыПеретаскивания.Значение;
	
	Если ТипЗнч(ПолученныйМассив) = Тип("Массив") Тогда
		
		Для Каждого ЭлементМассива Из ПолученныйМассив Цикл
			
			Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда 
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецЕсли;	
			
			НоваяСтрока = НачисленияНеНДФЛ.Добавить();
            ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			
			НачисленияНДФЛ.Удалить(ЭлементМассива);
			
		КонецЦикла;
		
	КонецЕсли;
	
	НачисленияНеНДФЛ.Сортировать("РеквизитДопУпорядочивания");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеНДФЛВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеНДФЛПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеНДФЛПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНачисленияСреднийЗаработокОбщий

&НаКлиенте
Процедура НачисленияСреднийЗаработокОбщийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для Каждого ИдентификаторСтроки Из ПараметрыПеретаскивания.Значение Цикл 
		
		ТекСтрока = НачисленияСреднийЗаработокОбщий.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ТекСтрока.ТолькоПросмотр Тогда
			Выполнение = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСреднийЗаработокОбщийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПолученныйМассив = ПараметрыПеретаскивания.Значение;
	
	Если ТипЗнч(ПолученныйМассив) = Тип("Массив") Тогда
		
		Для Каждого ЭлементМассива Из ПолученныйМассив Цикл
			
			Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда 
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецЕсли;	
			
			НоваяСтрока = НачисленияСреднийЗаработокОбщий.Добавить();
            ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			
			НачисленияНеСреднийЗаработокОбщий.Удалить(ЭлементМассива);
			
		КонецЦикла;
		
	КонецЕсли;
	
	НачисленияСреднийЗаработокОбщий.Сортировать("РеквизитДопУпорядочивания");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСреднийЗаработокОбщийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСреднийЗаработокОбщийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСреднийЗаработокОбщийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНачисленияНеСреднийЗаработокОбщий

&НаКлиенте
Процедура НачисленияНеСреднийЗаработокОбщийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Для Каждого ИдентификаторСтроки Из ПараметрыПеретаскивания.Значение Цикл 
		
		ТекСтрока = НачисленияНеСреднийЗаработокОбщий.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Если ТекСтрока.ТолькоПросмотр Тогда
			Выполнение = Ложь;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеСреднийЗаработокОбщийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПолученныйМассив = ПараметрыПеретаскивания.Значение;
	
	Если ТипЗнч(ПолученныйМассив) = Тип("Массив") Тогда
		
		Для Каждого ЭлементМассива Из ПолученныйМассив Цикл
			
			Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда 
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецЕсли;	
			
			НоваяСтрока = НачисленияНеСреднийЗаработокОбщий.Добавить();
            ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
			
			НачисленияСреднийЗаработокОбщий.Удалить(ЭлементМассива);
			
		КонецЦикла;
		
	КонецЕсли;
	
	НачисленияНеСреднийЗаработокОбщий.Сортировать("РеквизитДопУпорядочивания");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеСреднийЗаработокОбщийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеСреднийЗаработокОбщийПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеСреднийЗаработокОбщийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыПФРФССФОМС

&НаКлиенте
Процедура ПФР_ФСС_ФОМСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНеПФРНеФССНеФОМС

&НаКлиенте
Процедура НеПФР_НеФСС_НеФОМСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийТаблицыФормыНачисленияВключатьВФОТ

&НаКлиенте
Процедура НачисленияВключатьВФОТПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКоманд();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеВключатьВФОТВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФормуПланаВидовРасчета(Элемент, Поле);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияВключатьВФОТПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	ПеренестиВНачисленияВключатьВФОТ(Элементы.НачисленияНеВключатьВФОТ.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыНачисленияНеВключатьВФОТ

&НаКлиенте
Процедура НачисленияНеВключатьВФОТПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьКоманд();
КонецПроцедуры

&НаКлиенте
Процедура НачисленияВключатьВФОТВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФормуПланаВидовРасчета(Элемент, Поле);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНеВключатьВФОТПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	ПеренестиВНачисленияНеВключатьВФОТ(Элементы.НачисленияВключатьВФОТ.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	ДополнительныеПараметры = Новый Структура("Записать, Команда", Истина, Команда);
	
	Если Модифицированность Тогда 
		
		ТекстВопроса = НСтр("ru='Для того чтобы распечатать список, требуется сохранить изменения. Сохранить и продолжить?';uk='Для того щоб роздрукувати список, потрібно зберегти зміни. Зберегти і продовжити?'");
		
		Оповещение = Новый ОписаниеОповещения("Подключаемый_ВыполнитьКомандуПечатиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе 
		
		ДополнительныеПараметры.Записать = Ложь;
		Подключаемый_ВыполнитьКомандуПечатиЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечатиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Записать Тогда 
		ЗаписатьНаСервере();
	КонецЕсли;
	
	ОбъектыПечати = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПредопределенноеЗначение("ПланВидовРасчета.Начисления.ПустаяСсылка"));
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ДополнительныеПараметры.Команда, ЭтаФорма, ОбъектыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	ЗаписатьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьНаСервере();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛевоНДФЛ(Команда)
	
	ТекущиеДанные = Элементы.НачисленияНеНДФЛ.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияНДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияНеНДФЛ.Индекс(ТекущиеДанные);
		НачисленияНеНДФЛ.Удалить(ТекущаяСтрока);
		
		НачисленияНДФЛ.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПравоНДФЛ(Команда)
	
	ТекущиеДанные = Элементы.НачисленияНДФЛ.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияНеНДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияНДФЛ.Индекс(ТекущиеДанные);
		НачисленияНДФЛ.Удалить(ТекущаяСтрока);
		
		НачисленияНеНДФЛ.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЛевоСреднийЗаработокОбщий(Команда)
	
	ТекущиеДанные = Элементы.НачисленияНеСреднийЗаработокОбщий.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияСреднийЗаработокОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияНеСреднийЗаработокОбщий.Индекс(ТекущиеДанные);
		НачисленияНеСреднийЗаработокОбщий.Удалить(ТекущаяСтрока);
		
		НачисленияСреднийЗаработокОбщий.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравоСреднийЗаработокОбщий(Команда)
	
	ТекущиеДанные = Элементы.НачисленияСреднийЗаработокОбщий.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияНеСреднийЗаработокОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияСреднийЗаработокОбщий.Индекс(ТекущиеДанные);
		НачисленияСреднийЗаработокОбщий.Удалить(ТекущаяСтрока);
		
		НачисленияНеСреднийЗаработокОбщий.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛевоСоставФОТ(Команда)
	
	ПеренестиВНачисленияВключатьВФОТ(Элементы.НачисленияНеВключатьВФОТ.ТекущиеДанные);
		
КонецПроцедуры

&НаКлиенте
Процедура ПравоСоставФОТ(Команда)
	
	ПеренестиВНачисленияНеВключатьВФОТ(Элементы.НачисленияВключатьВФОТ.ТекущиеДанные);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	// Заполнение закладки НДФЛ
	НачисленияНДФЛ.Очистить();
	НачисленияНеНДФЛ.Очистить();
	ИсходнаяБазаНДФЛ.Очистить();
	
	КатегорииПоСвойствам = ПланыВидовРасчета.Начисления.КатегорииПоСвойствамНачислений(СвойстваПоКатегориям);
	
	БазаНДФЛ = Обработки.ГрупповоеРедактированиеНачислений.ОблагаемаяБазаНДФЛ();
	
	Выборка = БазаНДФЛ.ОблагаетсяНДФЛ.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияНДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		ОбязательноЗаполнятьНДФЛ = КатегорииПоСвойствам.КодДоходаНДФЛНеЗаполняется.Найти(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени) = Неопределено;
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		
		НоваяСтрока.ТолькоПросмотр = ОбязательноЗаполнятьНДФЛ Или НедоступныеСвойства.Найти("КодДоходаНДФЛ") <> Неопределено;
		НоваяСтрока.РедактироватьКодДохода = НедоступныеСвойства.Найти("КодДоходаНДФЛ") = Неопределено;
		
		// Заполнение исходной таблицы - для определения измененных видов расчета перед записью.
		НоваяСтрока = ИсходнаяБазаНДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
	Выборка = БазаНДФЛ.НеОблагаетсяНДФЛ.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияНеНДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		ОбязательноЗаполнятьНДФЛ = КатегорииПоСвойствам.КодДоходаНДФЛНеЗаполняется.Найти(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени) = Неопределено;
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		
		НоваяСтрока.ТолькоПросмотр = ОбязательноЗаполнятьНДФЛ Или НедоступныеСвойства.Найти("КодДоходаНДФЛ") <> Неопределено;
		НоваяСтрока.РедактироватьКодДохода = НедоступныеСвойства.Найти("КодДоходаНДФЛ") = Неопределено;
		
	КонецЦикла;
	
	// Заполнение закладки СреднийЗаработокОбщий.
	НачисленияСреднийЗаработокОбщий.Очистить();
	НачисленияНеСреднийЗаработокОбщий.Очистить();
	ИсходнаяБазаСреднийЗаработокОбщий.Очистить();
	
	БазаСреднегоЗаработкаОбщего = Обработки.ГрупповоеРедактированиеНачислений.СоставСреднегоЗаработкаОбщего();
	
	Выборка = БазаСреднегоЗаработкаОбщего.ВходитВСоставСреднегоЗаработка.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияСреднийЗаработокОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		НоваяСтрока.Индексируется = ?(Выборка.Индексируется, 0, 1);
		
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		НоваяСтрока.ТолькоПросмотр = НедоступныеСвойства.Найти("ВключатьВСреднийЗаработокОбщий") <> Неопределено;
		НоваяСтрока.ИндексируетсяТолькоПросмотр = НедоступныеСвойства.Найти("СреднийЗаработокОбщий") <> Неопределено;
		
		// Заполнение исходной таблицы - для определения измененных видов расчета перед записью.
		НоваяСтрока = ИсходнаяБазаСреднийЗаработокОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Индексируется = ?(Выборка.Индексируется, 0, 1);
		
	КонецЦикла;
	
	Выборка = БазаСреднегоЗаработкаОбщего.НеВходитВСоставСреднегоЗаработка.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияНеСреднийЗаработокОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		НоваяСтрока.Индексируется = ?(СвойстваНачисления.СреднийЗаработокОбщий <> Неопределено, 0, 1);
		
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		НоваяСтрока.ТолькоПросмотр = НедоступныеСвойства.Найти("ВключатьВСреднийЗаработокОбщий") <> Неопределено;
		НоваяСтрока.ИндексируетсяТолькоПросмотр = НедоступныеСвойства.Найти("СреднийЗаработокОбщий") <> Неопределено;
		
	КонецЦикла;
	
	
	// Заполнение закладки ПФР, ФСС, ФОМС.
	ПФР_ФСС_ФОМС.Очистить();
	НеПФР_НеФСС_НеФОМС.Очистить();
	
	БазаСтраховыхВзносов = Обработки.ГрупповоеРедактированиеНачислений.РасчетнаяБазаСтраховыхВзносов();
	
	Выборка = БазаСтраховыхВзносов.ОблагаетсяЦеликом.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = ПФР_ФСС_ФОМС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;

	Выборка = БазаСтраховыхВзносов.НеОблагается.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НеПФР_НеФСС_НеФОМС.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
	
	// Заполнение закладки СоставФОТ.
	НачисленияВключатьВФОТ.Очистить();
	НачисленияНеВключатьВФОТ.Очистить();
	ИсходнаяБазаСоставФОТ.Очистить();
	
	СоставФОТ = Обработки.ГрупповоеРедактированиеНачислений.СоставФОТ();
	
	Выборка = СоставФОТ.ВходятВФОТ.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияВключатьВФОТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		НоваяСтрока.ТолькоПросмотр = НедоступныеСвойства.Найти("ВключатьВФОТ") <> Неопределено;
		
		// Заполнение исходной таблицы - для определения измененных видов расчета перед записью.
		НоваяСтрока = ИсходнаяБазаСоставФОТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
	Выборка = СоставФОТ.НеВходятВФОТ.Выбрать();			   
	
	Пока Выборка.Следующий() Цикл 
		
		НоваяСтрока = НачисленияНеВключатьВФОТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		СвойстваНачисления = СвойстваПоКатегориям.Получить(Выборка.КатегорияНачисленияИлиНеоплаченногоВремени);
		Если СвойстваНачисления = Неопределено Тогда
			СвойстваНачисления = СвойстваПоКатегориям.Получить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПустаяСсылка());
		КонецЕсли;
		
		НедоступныеСвойства = СвойстваНачисления.НедоступныеСвойства;
		НоваяСтрока.ТолькоПросмотр = НедоступныеСвойства.Найти("ВключатьВФОТ") <> Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ИзмененныеВидыРасчета = Новый Соответствие;
	
	// Обработка закладки НДФЛ
	СохраненнаяБазаНДФЛ = ИсходнаяБазаНДФЛ.Выгрузить();
	ТекущаяБазаНДФЛ 	= НачисленияНДФЛ.Выгрузить(, "ВидРасчета, КодДоходаНДФЛ");
	
	ИзмененныеДанные = ИзмененныеДанныеСтруктура(СохраненнаяБазаНДФЛ, ТекущаяБазаНДФЛ);
	
	// Удаленные из списка виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.УдаленныеВидыРасчета Цикл 
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			РеквизитыВидаРасчета = Новый Структура("КодДоходаНДФЛ", Справочники.ВидыДоходовНДФЛ.ПустаяСсылка());
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
		Иначе 
			РеквизитыВидаРасчета.Вставить("КодДоходаНДФЛ", Справочники.ВидыДоходовНДФЛ.ПустаяСсылка());
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавленные в список виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.ДобавленныеВидыРасчета Цикл 
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			РеквизитыВидаРасчета = Новый Структура("КодДоходаНДФЛ", ТекСтрока.КодДоходаНДФЛ);
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
		Иначе 
			РеквизитыВидаРасчета.Вставить("КодДоходаНДФЛ", ТекСтрока.КодДоходаНДФЛ);
		КонецЕсли;
		
	КонецЦикла;
	
	// Исправленные виды расчета
	Для Каждого ТекСтрока Из ИзмененныеДанные.ИсправленныеВидыРасчета Цикл 
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			РеквизитыВидаРасчета = Новый Структура("КодДоходаНДФЛ", ТекСтрока.КодДоходаНДФЛ);
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
		Иначе 
			РеквизитыВидаРасчета.Вставить("КодДоходаНДФЛ", ТекСтрока.КодДоходаНДФЛ);
		КонецЕсли;
		
	КонецЦикла;
		
	// Обработка закладки СреднийЗаработокОбщий.
	СохраненнаяБазаСреднийЗаработокОбщий = ИсходнаяБазаСреднийЗаработокОбщий.Выгрузить();
	ТекущаяБазаСреднийЗаработокОбщий 	 = НачисленияСреднийЗаработокОбщий.Выгрузить(, "ВидРасчета, УчетНачисленийВСреднемЗаработкеОбщий, Индексируется");
	
	ИзмененныеДанные = ИзмененныеДанныеСтруктура(СохраненнаяБазаСреднийЗаработокОбщий, ТекущаяБазаСреднийЗаработокОбщий);
	
	// Удаленные из списка виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.УдаленныеВидыРасчета Цикл 
		
		СреднийЗаработокОбщий = Новый Структура;
		СреднийЗаработокОбщий.Вставить("ПорядокРасчета", Перечисления.ПорядокРасчетаСреднегоЗаработкаОбщий.Постановление2010);
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			
			РеквизитыВидаРасчета = Новый Структура;
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Ложь);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
			
		Иначе 
			
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Ложь);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавленные в список виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.ДобавленныеВидыРасчета Цикл 
		
		СреднийЗаработокОбщий = Новый Структура;
		СреднийЗаработокОбщий.Вставить("ПорядокРасчета", Перечисления.ПорядокРасчетаСреднегоЗаработкаОбщий.Постановление2010);
		СреднийЗаработокОбщий.Вставить("Значение", ТекСтрока.УчетНачисленийВСреднемЗаработкеОбщий);
		СреднийЗаработокОбщий.Вставить("Индексируется", ?(ТекСтрока.Индексируется = 0, Истина, Ложь));
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда
			
			РеквизитыВидаРасчета = Новый Структура;
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Истина);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
			
		Иначе
			
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Истина);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Исправленные виды расчета
	Для Каждого ТекСтрока Из ИзмененныеДанные.ИсправленныеВидыРасчета Цикл 
		
		СреднийЗаработокОбщий = Новый Структура;
		СреднийЗаработокОбщий.Вставить("ПорядокРасчета", Перечисления.ПорядокРасчетаСреднегоЗаработкаОбщий.Постановление2010);
		СреднийЗаработокОбщий.Вставить("Значение", ТекСтрока.УчетНачисленийВСреднемЗаработкеОбщий);
		СреднийЗаработокОбщий.Вставить("Индексируется", ?(ТекСтрока.Индексируется = 0, Истина, Ложь));
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		Если РеквизитыВидаРасчета = Неопределено Тогда
			
			РеквизитыВидаРасчета = Новый Структура;
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Истина);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
			
		Иначе
			
			РеквизитыВидаРасчета.Вставить("ВключатьВСреднийЗаработокОбщий", Истина);
			РеквизитыВидаРасчета.Вставить("СреднийЗаработокОбщий2010", СреднийЗаработокОбщий);
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	// Обработка закладки СоставФОТ
	СохраненнаяБазаНДФЛ = ИсходнаяБазаСоставФОТ.Выгрузить();
	ТекущаяБазаНДФЛ 	= НачисленияВключатьВФОТ.Выгрузить(, "ВидРасчета");
	
	ИзмененныеДанные = ИзмененныеДанныеСтруктура(СохраненнаяБазаНДФЛ, ТекущаяБазаНДФЛ);
	
	// Удаленные из списка виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.УдаленныеВидыРасчета Цикл 
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			РеквизитыВидаРасчета = Новый Структура;
			РеквизитыВидаРасчета.Вставить("ВключатьВФОТ", Ложь);
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
		Иначе
			РеквизитыВидаРасчета.Вставить("ВключатьВФОТ", Ложь);
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавленные в список виды расчета.
	Для Каждого ТекСтрока Из ИзмененныеДанные.ДобавленныеВидыРасчета Цикл 
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		
		РеквизитыВидаРасчета = ИзмененныеВидыРасчета.Получить(ТекСтрока.ВидРасчета);
		Если РеквизитыВидаРасчета = Неопределено Тогда 
			РеквизитыВидаРасчета = Новый Структура;
			РеквизитыВидаРасчета.Вставить("ВключатьВФОТ", Истина);
			ИзмененныеВидыРасчета.Вставить(ТекСтрока.ВидРасчета, РеквизитыВидаРасчета);
		Иначе
			РеквизитыВидаРасчета.Вставить("ВключатьВФОТ", Истина);
		КонецЕсли;
		
	КонецЦикла;
	
	// Запись измененных видов расчета.
	ВидыРасчетаМассив = Новый Массив;
	
	Для Каждого Элемент Из ИзмененныеВидыРасчета Цикл 
		
		ВидРасчетаОбъект = Элемент.Ключ.ПолучитьОбъект();
		РеквизитыВидаРасчета = Элемент.Значение; 
		
		ЗаполнитьЗначенияСвойств(ВидРасчетаОбъект, РеквизитыВидаРасчета);
		
		// Средний заработок общий
		ВключатьВСреднийЗаработокОбщий = Неопределено;
		
		Если РеквизитыВидаРасчета.Свойство("ВключатьВСреднийЗаработокОбщий", ВключатьВСреднийЗаработокОбщий) Тогда 
			
			СреднийЗаработокОбщий2010 = РеквизитыВидаРасчета.СреднийЗаработокОбщий2010;
			Если ВключатьВСреднийЗаработокОбщий Тогда 
				СтрокаТЧ = ВидРасчетаОбъект.СреднийЗаработокОбщий.Найти(СреднийЗаработокОбщий2010.ПорядокРасчета, "ПорядокРасчета");
				Если СтрокаТЧ = Неопределено Тогда
					СтрокаТЧ = ВидРасчетаОбъект.СреднийЗаработокОбщий.Добавить();
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, СреднийЗаработокОбщий2010);
			Иначе
				СтрокаТЧ = ВидРасчетаОбъект.СреднийЗаработокОбщий.Найти(СреднийЗаработокОбщий2010.ПорядокРасчета, "ПорядокРасчета");
				Если СтрокаТЧ <> Неопределено Тогда 
					ВидРасчетаОбъект.СреднийЗаработокОбщий.Удалить(СтрокаТЧ);
				КонецЕсли;	
			КонецЕсли;
			
		КонецЕсли;
		
		
		Если ВидРасчетаОбъект.ПроверитьЗаполнение() Тогда 
			ВидыРасчетаМассив.Добавить(ВидРасчетаОбъект);
		КонецЕсли;
		
	КонецЦикла;
	
	РасчетЗарплатыРасширенный.ЗаписатьПакетВидовРасчета(ВидыРасчетаМассив);
	
	ЗаполнитьНаСервере();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ИзмененныеДанныеСтруктура(ИсходнаяТаблица, ТекущаяТаблица)
	
	ДобавленныеВидыРасчета 	= ИсходнаяТаблица.СкопироватьКолонки();
	ИсправленныеВидыРасчета = ИсходнаяТаблица.СкопироватьКолонки();
	УдаленныеВидыРасчета 	= ИсходнаяТаблица.СкопироватьКолонки();
	
	СравниваемыеКолонки = Новый Массив;
	Для Каждого Колонка Из ИсходнаяТаблица.Колонки Цикл
		СравниваемыеКолонки.Добавить(Колонка.Имя);
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(СравниваемыеКолонки, "ВидРасчета");
	
	Для Каждого ТекСтрока Из ИсходнаяТаблица Цикл
		ВидРасчета = ТекущаяТаблица.Найти(ТекСтрока.ВидРасчета, "ВидРасчета");
		Если ВидРасчета = Неопределено Тогда 
			НоваяСтрока = УдаленныеВидыРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекСтрока Из ТекущаяТаблица Цикл
		ВидРасчета = ИсходнаяТаблица.Найти(ТекСтрока.ВидРасчета, "ВидРасчета");
		Если ВидРасчета = Неопределено Тогда 
			НоваяСтрока = ДобавленныеВидыРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		Иначе 
			Для Каждого ИмяКолонки Из СравниваемыеКолонки Цикл
				Если ВидРасчета[ИмяКолонки] <> ТекСтрока[ИмяКолонки] Тогда
					НоваяСтрока = ИсправленныеВидыРасчета.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ИзмененныеДанные = Новый Структура;
	ИзмененныеДанные.Вставить("УдаленныеВидыРасчета", УдаленныеВидыРасчета);
	ИзмененныеДанные.Вставить("ДобавленныеВидыРасчета", ДобавленныеВидыРасчета);
	ИзмененныеДанные.Вставить("ИсправленныеВидыРасчета", ИсправленныеВидыРасчета);
	
	Возврат ИзмененныеДанные;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	ТекущиеДанные = Элементы.НачисленияНДФЛ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьПравоНДФЛ = Ложь;
	Иначе
		ДоступностьПравоНДФЛ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПравоНДФЛ",
		"Доступность",
		ДоступностьПравоНДФЛ);
	
	ТекущиеДанные = Элементы.НачисленияНеНДФЛ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьЛевоНДФЛ = Ложь;
	Иначе
		ДоступностьЛевоНДФЛ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛевоНДФЛ",
		"Доступность",
		ДоступностьЛевоНДФЛ);
		
	ТекущиеДанные = Элементы.НачисленияСреднийЗаработокОбщий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьПравоСреднийЗаработокОбщий = Ложь;
	Иначе
		ДоступностьПравоСреднийЗаработокОбщий = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПравоСреднийЗаработокОбщий",
		"Доступность",
		ДоступностьПравоСреднийЗаработокОбщий);
		
	ТекущиеДанные = Элементы.НачисленияНеСреднийЗаработокОбщий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьЛевоСреднийЗаработокОбщий = Ложь;
	Иначе
		ДоступностьЛевоСреднийЗаработокОбщий = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛевоСреднийЗаработокОбщий",
		"Доступность",
		ДоступностьЛевоСреднийЗаработокОбщий);
		
		
	ТекущиеДанные = Элементы.НачисленияВключатьВФОТ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьПравоСоставФОТ = Ложь;
	Иначе
		ДоступностьПравоСоставФОТ= Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПравоСоставФОТ",
		"Доступность",
		ДоступностьПравоСоставФОТ);
	
	ТекущиеДанные = Элементы.НачисленияНеВключатьВФОТ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТолькоПросмотр Тогда 
		ДоступностьЛевоСоставФОТ = Ложь;
	Иначе
		ДоступностьЛевоСоставФОТ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЛевоСоставФОТ",
		"Доступность",
		ДоступностьЛевоСоставФОТ);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыВыбораКодаДоходаНДФЛ()
	
	ТекущиеДанные = Элементы.НачисленияНДФЛ.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СвойстваНачисления = СвойстваПоКатегориям.Получить(ТекущиеДанные.КатегорияНачисленияИлиНеоплаченногоВремени);
	
	Если СвойстваНачисления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивПараметровВыбора = Новый Массив;
	
	Если СвойстваНачисления.ПараметрыВыбора <> Неопределено Тогда
		Для Каждого КлючИЗначение Из СвойстваНачисления.ПараметрыВыбора Цикл
			ИмяЭлемента = КлючИЗначение.Ключ;
			Если ИмяЭлемента = "КодДоходаНДФЛ" И КлючИЗначение.Значение <> Неопределено Тогда
				Для Каждого ОписаниеПараметра Из КлючИЗначение.Значение Цикл
					Если ТипЗнч(ОписаниеПараметра.Значение) = Тип("Массив") Тогда
						ЗначениеПараметра = Новый ФиксированныйМассив(ОписаниеПараметра.Значение);
					Иначе
						ЗначениеПараметра = ОписаниеПараметра.Значение;
					КонецЕсли;
					МассивПараметровВыбора.Добавить(Новый ПараметрВыбора(СтрЗаменить(ОписаниеПараметра.Ключ, "_", "."), ЗначениеПараметра));
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.НачисленияКодДоходаНДФЛ.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПланаВидовРасчета(Элемент, Поле)

	Если Поле.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда 
			ОткрытьФорму("ПланВидовРасчета.Начисления.Форма.ФормаВидаРасчета", Новый Структура("Ключ", ТекущиеДанные.ВидРасчета));  
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВНачисленияНеВключатьВФОТ(ТекущиеДанные);

	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияНеВключатьВФОТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияВключатьВФОТ.Индекс(ТекущиеДанные);
		НачисленияВключатьВФОТ.Удалить(ТекущаяСтрока);
		
		НачисленияНеВключатьВФОТ.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВНачисленияВключатьВФОТ(ТекущиеДанные);

	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ТолькоПросмотр Тогда
		
		НоваяСтрока = НачисленияВключатьВФОТ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		
		ТекущаяСтрока = НачисленияНеВключатьВФОТ.Индекс(ТекущиеДанные);
		НачисленияНеВключатьВФОТ.Удалить(ТекущаяСтрока);
		
		НачисленияВключатьВФОТ.Сортировать("РеквизитДопУпорядочивания");
		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

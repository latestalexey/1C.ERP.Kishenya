
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.РабочееМестоМенеджераПоДоставке.МакетПредупреждение");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СостоянияИРеквизитыДоставки.Распоряжение КАК Распоряжение,
	|	СостоянияИРеквизитыДоставки.ОсобыеУсловияПеревозкиОписание КАК Описание,
	|	СостоянияИРеквизитыДоставки.ПолучательОтправитель КАК ПолучательОтправитель,
	|	СостоянияИРеквизитыДоставки.Адрес КАК Адрес
	|ИЗ
	|	РегистрСведений.СостоянияИРеквизитыДоставки КАК СостоянияИРеквизитыДоставки
	|ГДЕ
	|	СостоянияИРеквизитыДоставки.Распоряжение В(&Распоряжения)
	|	И СостоянияИРеквизитыДоставки.ОсобыеУсловияПеревозки = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	СостоянияИРеквизитыДоставки.ПолучательОтправитель,
	|	СостоянияИРеквизитыДоставки.Распоряжение";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Распоряжения", Параметры.Распоряжения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("Отступ"));
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполняемаяОбласть = Макет.ПолучитьОбласть("СтрокаТаблицы");
		
		ТекстРаспоряжение = НСтр("ru='%ПолучательОтправитель, %Распоряжение';uk='%ПолучательОтправитель, %Распоряжение'");
		ТекстРаспоряжение = СтрЗаменить(ТекстРаспоряжение, "%ПолучательОтправитель", Выборка.ПолучательОтправитель);
		ТекстРаспоряжение = СтрЗаменить(ТекстРаспоряжение, "%Распоряжение", Выборка.Распоряжение);
		ЗаполняемаяОбласть.Параметры.ТекстРаспоряжение = ТекстРаспоряжение;
		ЗаполняемаяОбласть.Параметры.Заполнить(Выборка);
		
		ТабличныйДокумент.Вывести(ЗаполняемаяОбласть);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	
КонецПроцедуры

#КонецОбласти
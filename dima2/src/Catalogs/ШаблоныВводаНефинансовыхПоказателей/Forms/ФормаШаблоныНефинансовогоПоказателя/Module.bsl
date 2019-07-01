
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметр = Список.Параметры.Элементы.Найти("Показатель");
	Параметр.Значение = Параметры.Показатель;
	Параметр.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура("ПоказательЗаполнения", Список.Параметры.Элементы.Найти("Показатель").Значение);
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаимодействия"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при создании нового контакта.
// Используется, если для одного или нескольких видов контактов требуется, 
// чтобы вместо основной формы при их создании открывалась другая форма.
// Например, это может быть форма помощника создания нового элемента справочника.
//
// Параметры:
//  ТипКонтакта   - Строка    - Имя справочника контакта.
//  ПараметрФормы - Структура - Параметр, который передается при открытии.
//
// Возвращаемое значение:
//  Булево - Ложь, если открытие нестандартной формы не выполнено, Истина в обратном случае.
//
// Пример реализации:
//	Если ТипКонтакта = "Партнеры" Тогда
//		ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрФормы);
//		Возврат Истина;
//	КонецЕсли;
//	
//	Возврат Ложь;
//
Функция СоздатьКонтактНестандартнаяФорма(ТипКонтакта, ПараметрФормы)  Экспорт
	
	Если ТипКонтакта = "Партнеры" Тогда
		ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрФормы,);
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

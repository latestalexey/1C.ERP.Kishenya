////////////////////////////////////////////////////////////////////////////////
// Подсистема "Анкетирование"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Преобразовывает массив в строку,
//
// Параметры:
//  Массив      - Массив - массив, который будет преобразован в строку.
//  Разделитель - Строка - строка, которая будет разделять элементы массива.
//
// Возвращаемое значение:
//   Строка   - строка получившаяся в результате преобразования массива.
//
Функция ПреобразоватьМассивВСтроку(Массив,Разделитель = "")Экспорт
	
	СтрокаРезультат = "";
	
	Для каждого Элемент Из Массив Цикл
		СтрокаРезультат = СтрокаРезультат + Строка(Элемент) + Разделитель;  
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции

// Удаляет из строки последние символы, если они равны подстроке удаления,
// до тех пор, пока последние символы будут не равны подстроке удаления.   
//
// Параметры:
//  ВходящаяСтрока    - Строка - строка, которая будет обрабатываться.
//  ПодстрокаУдаления - Строка - подстрока, которая будет удалена из конца строки.
//  Разделитель       - Строка - если задан, то удаление происходит только в том случае, 
//                        если подстрока удаления находится целиком после разделителя.
//
// Возвращаемое значение:
//   Строка  - получившаяся в результате обработки строка.
//
Функция УдалитьПоследниеСимволыИзСтроки(ВходящаяСтрока,ПодстрокаУдаления,Разделитель = Неопределено) Экспорт
	
	Пока Прав(ВходящаяСтрока,СтрДлина(ПодстрокаУдаления)) = ПодстрокаУдаления Цикл
		
		Если Разделитель <> Неопределено Тогда
			Если СРЕД(ВходящаяСтрока,СтрДлина(ВходящаяСтрока)-СтрДлина(ПодстрокаУдаления)-СтрДлина(Разделитель),СтрДлина(Разделитель)) = Разделитель Тогда
				Возврат ВходящаяСтрока;
			КонецЕсли;
		КонецЕсли;
		ВходящаяСтрока = ЛЕВ(ВходящаяСтрока,СтрДлина(ВходящаяСтрока) - СтрДлина(ПодстрокаУдаления));
		
	КонецЦикла;
	
	Возврат ВходящаяСтрока;
	
КонецФункции

// Формирует имя вопроса на основании уникального идентификатора строки дерева анкеты.
//
// Параметры:
//  Ключ  - УникальныйИдентификатор - ключ, на основе которого будет формироваться имя вопроса.
//
// Возвращаемое значение:
//  Строка - получившаяся в результате обработки строка.
//
Функция ПолучитьИмяВопроса(Ключ) Экспорт
	
	Возврат "Вопрос_" + СтрЗаменить(Ключ,"-","_");

КонецФункции

// Заново формирует нумерацию дерева анкеты.
Процедура СформироватьНумерациюДерева(ДеревоАнкеты,ПреобразовыватьФормулировку = Ложь) Экспорт

	Если ДеревоАнкеты.ПолучитьЭлементы()[0].ТипСтроки = "Корень" Тогда 
		ЗначимыеЭлементыДерева = ДеревоАнкеты.ПолучитьЭлементы()[0].ПолучитьЭлементы();
	Иначе
		ЗначимыеЭлементыДерева = ДеревоАнкеты.ПолучитьЭлементы();
	КонецЕсли;
	
	СформироватьНумерациюЭлементовДерева(ЗначимыеЭлементыДерева,1,Новый Массив,ПреобразовыватьФормулировку);

КонецПроцедуры 

// Вызывается рекурсивно при формировании полного кода строк дерева анкеты.
Процедура СформироватьНумерациюЭлементовДерева(СтрокиДерева, УровеньРекурсии, МассивПолныйКод, ПреобразовыватьФормулировку)
	
	Если МассивПолныйКод.Количество() < УровеньРекурсии Тогда
		МассивПолныйКод.Добавить(0);
	КонецЕсли;
	
	Для каждого Элемент Из СтрокиДерева Цикл
		
		Если Элемент.ТипСтроки = "Вступление" ИЛИ Элемент.ТипСтроки = "Заключение" Тогда
			Продолжить;
		КонецЕсли;	
		
		МассивПолныйКод[УровеньРекурсии-1] = МассивПолныйКод[УровеньРекурсии-1] + 1;
		Для инд = УровеньРекурсии По МассивПолныйКод.Количество()-1 Цикл
			МассивПолныйКод[инд] = 0;
		КонецЦикла;
		
		ПолныйКод = ПреобразоватьМассивВСтроку(МассивПолныйКод,".");
		ПолныйКод = УдалитьПоследниеСимволыИзСтроки(ПолныйКод,"0.",".");
		
		Элемент.ПолныйКод = ПолныйКод;
		Если ПреобразовыватьФормулировку Тогда
			Элемент.Формулировка = Элемент.ПолныйКод + Элемент.Формулировка;
		КонецЕсли;
		
		ПодчиненныеЭлементыСтрокиДерева = Элемент.ПолучитьЭлементы();
		Если ПодчиненныеЭлементыСтрокиДерева.Количество() > 0 Тогда
			СформироватьНумерациюЭлементовДерева(ПодчиненныеЭлементыСтрокиДерева,?(Элемент.ТипСтроки ="Вопрос",УровеньРекурсии,УровеньРекурсии + 1),МассивПолныйКод,ПреобразовыватьФормулировку);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Находит первую строку в заданной колонке, с заданным значением в коллекции ДанныеФормыДерево.
Функция НайтиСтрокуВДанныхФормыДерево(ГдеИскать,Значение,Колонка,ИскатьВПодчиненных) Экспорт
	
	ЭлементыДерева = ГдеИскать.ПолучитьЭлементы();
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева[Колонка] = Значение Тогда
			Возврат ЭлементДерева.ПолучитьИдентификатор();
		ИначеЕсли  ИскатьВПодчиненных Тогда
			НайденныйИдентификаторСтроки =  НайтиСтрокуВДанныхФормыДерево(ЭлементДерева,Значение,Колонка,ИскатьВПодчиненных);
			Если НайденныйИдентификаторСтроки >=0 Тогда
				Возврат НайденныйИдентификаторСтроки;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат -1;
	
КонецФункции

// Возвращает код картинки в зависимости от типа вопроса и принадлежности к разделу.
//
// Параметры:
//  ЭтоРаздел  - Булево - признак раздела.
//  ТипВопроса - Перечисление.ТипыВопросовШаблонаАнкеты.
//
// Возвращаемое значение:
//   Число   - код картинки для отображения в дереве.
//
Функция ПолучитьКодКартинкиШаблонаАнкеты(ЭтоРаздел,ТипВопроса = Неопределено) Экспорт
	
	Если ЭтоРаздел Тогда
		Возврат 1;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Простой") Тогда
		Возврат 2;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") Тогда
		Возврат 4;
	ИначеЕсли ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.Табличный") Тогда
		Возврат 3;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Процедура ПереключитьВидимостьГруппТелаАнкеты(Форма, ВидимостьТелаАнкеты) Экспорт
	
	Форма.Элементы.ГруппаТелоАнкеты.Видимость = ВидимостьТелаАнкеты;
	Форма.Элементы.ГруппаОжидание.Видимость    = НЕ ВидимостьТелаАнкеты;
	
КонецПроцедуры


#КонецОбласти

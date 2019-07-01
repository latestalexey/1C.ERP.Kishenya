
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	ПараметрыПодключения.Вставить("ИДУстройства", Неопределено);

	// Проверка настроенных параметров.
	Порт               = Неопределено;
	Таймаут            = Неопределено;
	КоличествоПовторов = Неопределено;
	Параметры.Свойство("Порт"    , Порт);
	Параметры.Свойство("Таймаут" , Таймаут);
	Параметры.Свойство("КоличествоПовторов", КоличествоПовторов);
	
	Если Порт = Неопределено
		ИЛИ Таймаут = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
        |Для корректной работы устройства необходимо задать параметры его работы.
        |Сделать это можно при помощи формы ""Настройка параметров"" модели
        |подключаемого оборудования в форме ""Подключение и настройка оборудования"".'
        |;uk='Не настроєні параметри пристрою.
        |Для коректної роботи пристрою необхідно задати параметри його роботи.
        |Зробити це можна за допомогою форми ""Настройка параметрів"" моделі
        |обладнання для підключення в формі ""Підключення та настройка обладнання"".'"));
		Результат = Ложь;
	КонецЕсли;

	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Таймаут);
	МассивЗначений.Добавить(?(Параметры.КоличествоПовторов = Неопределено, 1, Параметры.КоличествоПовторов));
	
	Если Результат Тогда
		Ответ = ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ТекстОшибки);
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Вывод строк на дисплей
	Если Команда = "ВывестиСтрокуНаДисплейПокупателя" ИЛИ Команда = "DisplayText" Тогда
		СтрокаТекста = ВходныеПараметры[0];
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);

	// Очистка дисплея
	ИначеЕсли Команда = "ОчиститьДисплейПокупателя" ИЛИ Команда = "ClearText" Тогда
		Результат = ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получить параметры вывода
	ИначеЕсли Команда = "ПолучитьПараметрыВывода" ИЛИ Команда = "GetOutputOptions" Тогда
		Результат = ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" ИЛИ Команда = "GetVersion" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.';uk='Команда ""%Команда%"" не підтримується цим драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет вывод списка строк на дисплей покупателя.
//
Функция ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)

	Результат = Истина;

	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаТекста, Параметры.ОтображатьНаДисплее));

	Ответ = ОбъектДрайвера.ВывестиСтрокуНаДисплейПокупателя(ПараметрыПодключения.ИДУстройства, МассивСтрок);
	Если Не Ответ Тогда
		Результат = Ложь;
		ОбъектДрайвера.ПолучитьОшибку(ОбъектДрайвера.ОписаниеОшибки);
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеОшибки);
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Функция осуществляет очистку дисплея покупателя.
//
Функция ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Ответ = ОбъектДрайвера.ОчиститьДисплейПокупателя(ПараметрыПодключения.ИДУстройства);
	Если Не Ответ Тогда
		Результат = Ложь;
		ОбъектДрайвера.ПолучитьОшибку(ОбъектДрайвера.ОписаниеОшибки);
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеОшибки);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает параметры вывода на дисплей покупателя).
Функция ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	ВыходныеПараметры.Очистить();  
	ВыходныеПараметры.Добавить(20);
	ВыходныеПараметры.Добавить(2);
		
	Возврат Результат;

КонецФункции

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства';uk='Помилка при підключенні обладнання'"));
	Иначе
		СтрокаТекста = НСтр("ru='Наименование товара';uk='Найменування товару'")+Символы.ПС+НСтр("ru='Итоговая сумма';uk='Підсумкова сума'");
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);
		МенеджерОборудованияКлиент.Пауза(5);
		Если Результат Тогда
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(НСтр("ru='Тест успешно выполнен';uk='Тест успішно виконаний'"));
		КонецЕсли;
	КонецЕсли;

	ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен';uk='Встановлений'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена';uk='Не визначена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти
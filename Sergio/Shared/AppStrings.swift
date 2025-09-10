//
//  AppStrings.swift
//  Sergio
//
//  Created by sergio jara on 24/08/25.
//

import Foundation

// MARK: - App Strings
struct AppStrings {
    
    // MARK: - Welcome Feature
    struct Welcome {
        static let title = "Bem-vindo ao Quiz Sergio!"
        static let subtitle = "Teste seus conhecimentos com nosso quiz interativo"
        static let namePrompt = "Por favor, digite seu nome para começar"
        static let namePlaceholder = "Seu nome"
        static let startButton = "Iniciar Quiz"
        static let nameValidationError = "O nome deve ter entre 2 e 50 caracteres"
        static let footerTitle = "Pronto para se desafiar?"
        static let footerSubtitle = "10 perguntas • Múltipla escolha • Feedback instantâneo"
    }
    
    // MARK: - Quiz Feature
    struct Quiz {
        static let tabTitle = "Quiz"
        static let resultsTabTitle = "Resultados"
        static let readyToStart = "Pronto para começar o quiz?"
        static let tapWelcomeToBegin = "Toque no botão de boas-vindas para começar"
        static let questionNumber = "Pergunta %d de %d"
        static let nextButton = "Próximo"
        static let submitButton = "Enviar"
        static let loadingQuestions = "Carregando perguntas..."
        static let errorLoadingQuestions = "Erro ao carregar perguntas. Tente novamente."
        static let timeRemaining = "Tempo restante: %d segundos"
        static let correctAnswer = "Correto!"
        static let incorrectAnswer = "Incorreto!"
        static let explanation = "Explicação:"
        static let helloFormat = "Olá, %@!"
        static let questionNumberFormat = "Pergunta %d de %d"
        static let selectAnswer = "Selecione sua resposta:"
        static let submitAnswer = "Enviar Resposta"
        static let finishQuiz = "Finalizar Quiz"
        static let nextQuestion = "Próxima Pergunta"
        static let noQuestionAvailable = "Nenhuma pergunta disponível"
        static let loadQuestion = "Carregar Pergunta"
        static let error = "Erro"
        static let ok = "OK"
        static let unknownError = "Ocorreu um erro desconhecido"
        static let loadingQuestion = "Carregando pergunta..."
    }
    
    // MARK: - Results Feature
    struct Results {
        static let tabTitle = "Resultados"
        static let performanceTitle = "Seu Desempenho no Quiz"
        static let totalQuizzes = "Total de Quizzes"
        static let averageScore = "Pontuação Média"
        static let recentResults = "Resultados Recentes"
        static let completeQuizForResults = "Complete um quiz para ver seus resultados aqui"
        static let quizComplete = "Quiz Concluído!"
        static let congratulationsFormat = "Parabéns, %@!"
        static let score = "Pontuação"
        static let percentage = "Porcentagem"
        static let performance = "Desempenho"
        static let restartQuiz = "Reiniciar Quiz"
        static let backToWelcome = "Voltar ao Início"
        static let scoreTitle = "Sua Pontuação"
        static let congratulations = "Parabéns!"
        static let goodJob = "Bom trabalho!"
        static let keepTrying = "Continue tentando!"
        static let scoreFormat = "%d de %d"
        static let percentageFormat = "%.0f%%"
        static let correctAnswers = "Respostas Corretas: %d"
        static let incorrectAnswers = "Respostas Incorretas: %d"
        static let timeSpent = "Tempo Gasto: %d segundos"
        static let averageTime = "Tempo Médio: %.1f segundos"
        static let noResultsYet = "Nenhum resultado ainda. Faça um quiz para ver seu desempenho!"
        static let takeAnotherQuiz = "Fazer Outro Quiz"
        
        // MARK: - Score Messages
        static let excellentScore = "Excelente! Você é um mestre do quiz!"
        static let greatScore = "Ótimo trabalho! Você sabe das coisas!"
        static let goodScore = "Bom esforço! Continue aprendendo!"
        static let fairScore = "Nada mal! Há espaço para melhorar!"
        static let poorScore = "Continue praticando! Você vai melhorar!"
    }
}

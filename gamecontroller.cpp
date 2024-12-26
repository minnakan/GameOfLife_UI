#include "gamecontroller.h"
#include <QDebug>

GameController::GameController(QObject *parent)
    : QObject(parent)
    , m_rows(25)
    , m_columns(25)
{
    m_timer.setInterval(100);
    connect(&m_timer, &QTimer::timeout, this, &GameController::updateGame);

    initializeGrid();
}

void GameController::registerType()
{
    qmlRegisterType<GameController>("GameController", 1, 0, "GameController");
}

void GameController::setRows(int rows)
{
    if (m_rows != rows) {
        m_rows = rows;
        initializeGrid();
        emit rowsChanged(rows);
    }
}

void GameController::setColumns(int columns)
{
    if (m_columns != columns) {
        m_columns = columns;
        initializeGrid();
        emit columnsChanged(columns);
    }
}

void GameController::initializeGrid()
{
    m_grid.resize(m_rows * m_columns);
    m_nextGrid.resize(m_rows * m_columns);
    std::fill(m_grid.begin(), m_grid.end(), false);
    std::fill(m_nextGrid.begin(), m_nextGrid.end(), false);
}

void GameController::initializeCells()
{
    for (int i = 0; i < m_grid.size(); ++i) {
        emit cellChanged(i, m_grid[i]);
    }
}

void GameController::startGame()
{
    if (!m_timer.isActive()) {
        m_timer.start();
        emit gameStarted();
        emit isRunningChanged(true);
    }
}

void GameController::stopGame()
{
    if (m_timer.isActive()) {
        m_timer.stop();
        emit gameStopped();
        emit isRunningChanged(false);
    }
}

void GameController::clearGame()
{
    stopGame();
    std::fill(m_grid.begin(), m_grid.end(), false);

    // Notify all cells that they are now dead
    for (int i = 0; i < m_grid.size(); ++i) {
        emit cellChanged(i, false);
    }

    emit gameCleared();
}

void GameController::setCellState(int index, bool alive)
{
    if (index >= 0 && index < m_grid.size() && m_grid[index] != alive) {
        m_grid[index] = alive;
        emit cellChanged(index, alive);
    }
}

void GameController::toggleCell(int index)
{
    if (index >= 0 && index < m_grid.size()) {
        m_grid[index] = !m_grid[index];
        emit cellChanged(index, m_grid[index]);
    }
}

int GameController::countNeighbors(int index) const
{
    int count = 0;
    int row = index / m_columns;
    int col = index % m_columns;

    for (int i = -1; i <= 1; ++i) {
        for (int j = -1; j <= 1; ++j) {
            if (i == 0 && j == 0) continue;

            int newRow = row + i;
            int newCol = col + j;

            //Wrapping
            if (newRow < 0) newRow = m_rows - 1;
            if (newRow >= m_rows) newRow = 0;
            if (newCol < 0) newCol = m_columns - 1;
            if (newCol >= m_columns) newCol = 0;

            int neighborIndex = newRow * m_columns + newCol;
            if (m_grid[neighborIndex]) {
                count++;
            }
        }
    }

    return count;
}

void GameController::updateGame()
{
    // Calculate next generation
    for (int i = 0; i < m_grid.size(); ++i) {
        int neighbors = countNeighbors(i);
        bool currentState = m_grid[i];
        if (currentState) {
            // Any live cell with fewer than two live neighbors dies
            // Any live cell with more than three live neighbors dies
            // Any live cell with two or three live neighbors lives
            m_nextGrid[i] = (neighbors == 2 || neighbors == 3);
        } else {
            // Any dead cell with exactly three live neighbors becomes alive
            m_nextGrid[i] = (neighbors == 3);
        }
    }

    for (int i = 0; i < m_grid.size(); ++i) {
        if (m_grid[i] != m_nextGrid[i]) {
            m_grid[i] = m_nextGrid[i];
            emit cellChanged(i, m_grid[i]);
        }
    }
}

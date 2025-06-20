-- =====================================
-- 🚀 Auto Nhận Nhiệm Vụ + Dịch Chuyển
-- =====================================

-- Dữ liệu nhiệm vụ & quái theo cấp (rút gọn, chỉ demo vài cấp đầu, bạn có thể thêm tiếp)
local NhiemVuTheoCap = {
    [1] = {
        Ten = "Bandit [Lv. 5]",
        NPC = "Bandit Quest",
        ViTri = CFrame.new(1060, 17, 1547),
        TenQuest = "BanditQuest1",
        LevelYeuCau = 1,
        TenBoss = "Bandit"
    },
    [10] = {
        Ten = "Monkey [Lv. 14]",
        NPC = "Monkey Quest",
        ViTri = CFrame.new(-1602, 37, 153),
        TenQuest = "JungleQuest",
        LevelYeuCau = 10,
        TenBoss = "Monkey"
    },
    -- Bạn thêm tiếp các đảo khác ở đây cho đủ 8000+ dòng
}

-- Tự nhận nhiệm vụ đúng cấp
function TimNhiemVuHienTai()
    local level = game.Players.LocalPlayer.Data.Level.Value
    local capGanNhat = 1

    for cap, data in pairs(NhiemVuTheoCap) do
        if level >= cap and cap >= capGanNhat then
            capGanNhat = cap
        end
    end

    return NhiemVuTheoCap[capGanNhat]
end

function NhanNhiemVu()
    local nv = TimNhiemVuHienTai()
    if not nv then return end

    repeat wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = nv.ViTri + Vector3.new(0, 2, 0)
        fireclickdetector(game:GetService("Workspace").NPCs:FindFirstChild(nv.NPC):FindFirstChildOfClass("ClickDetector"))
        wait(1.2)
    until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main"):FindFirstChild("Quest").Visible
end

-- Tự di chuyển đến quái để farm
function DiChuyenDenQuai()
    local nv = TimNhiemVuHienTai()
    if not nv then return end

    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == nv.Ten and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
            break
        end
    end
end

-- Gắn vào Auto Farm Toggle
function AutoFarm()
    spawn(function()
        while getgenv().AutoFarmLevel do
            pcall(function()
                NhanNhiemVu()
                wait(0.5)
                DiChuyenDenQuai()
                wait(0.5)
            end)
            wait(1)
        end
    end)
end
